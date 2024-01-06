//
//  ArticlesListView.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 29/12/2023.
//

import SwiftUI

struct ArticlesListView: View {
    // MARK: - Properties

    @Environment(\.openURL) private var openURL
    @State private var viewModel = ArticleViewModel()

    // MARK: - Body

    var body: some View {
        VStack {
            List(viewModel.articles) { article in
                ArticleListItem(article: article)
                    .swipeActions {
                        if let url = article.url {
                            ShareLink(item: url)
                                .labelStyle(.iconOnly)
                                .tint(.accentColor)
                        }
                    }
                    .onTapGesture {
                        didSelect(article: article)
                    }
            }

            if !viewModel.errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                    Text(viewModel.errorMessage)
                }
                .padding()
            }
        }
        .task {
            await loadArticles()
        }
        .refreshable {
            await loadArticles()
        }
    }

    // MARK: - Private Methods

    private func loadArticles() async {
        await viewModel.loadArticles()
    }

    private func didSelect(article: Article) {
        if let url = article.url {
            openURL(url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
    }
}
