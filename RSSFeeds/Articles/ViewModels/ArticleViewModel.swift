//
//  ArticleViewModel.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 02/01/2024.
//

import Foundation

@Observable
final class ArticleViewModel {
    // MARK: - Properties
    
    /// The list of articles to display.
    var articles: [Article] = []

    /// Error message to display if needed. Default value is `""`.
    var errorMessage = ""

    // MARK: - Private Methods

    private func loadFeed(from url: URL) async -> FeedParser.Feed {
        let parser = FeedParser()
        
        do {
            return try await parser.parse(url: url)
        } catch {
            self.errorMessage = error.localizedDescription
        }

        return .unknown
    }

    // MARK: - Public Methods

    func loadArticles() async {
        errorMessage = "" // Reset error

        let loadedArticles = await withTaskGroup(of: FeedParser.Feed.self, returning: [Article].self) { taskGroup in
            let urls = [
                URL(string: "https://www.apple.com/newsroom/rss-feed.rss")!,
                URL(string: "https://developer.apple.com/news/rss/news.rss")!
            ]

            for url in urls {
                taskGroup.addTask { await self.loadFeed(from: url) }
            }

            var articles: [Article] = []

            for await result in taskGroup {
                switch result {
                case .rss(let rssFeed):
                    articles.append(contentsOf: rssFeed.items.map { Article(from: $0) })

                case .atom(let atomFeed):
                    articles.append(contentsOf: atomFeed.entries.map { Article(from: $0) })

                case .unknown:
                    break
                }
            }

            return articles
        }

        articles = loadedArticles.sorted(using: KeyPathComparator(\.publicationDate, order: .reverse))
    }
}
