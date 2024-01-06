//
//  Article.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 29/12/2023.
//

import Foundation

struct Article: Identifiable, Hashable {
    // MARK: - Properties

    let id: UUID
    let title: String
    let description: String?
    let publicationDate: Date
    let url: URL?
    let imageURL: URL?

    // MARK: - Initializers

    init(id: UUID = UUID(), title: String, description: String?, publicationDate: Date, url: URL?, imageURL: URL?) {
        self.id = id
        self.title = title
        self.description = description
        self.publicationDate = publicationDate
        self.url = url
        self.imageURL = imageURL
    }

    init(from atomEntry: AtomEntry) {
        // Get the first link with a non-nil media type.
        let imagePath = atomEntry.links.first(where: { $0.type != nil })?.href ?? ""

        // Get the first lunk with a nil media type as article URL.
        let articlePath = atomEntry.links.first(where: { $0.type == nil })?.href ?? ""

        self.init(
            title: atomEntry.title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            description: atomEntry.description,
            publicationDate: atomEntry.updateDate ?? .now,
            url: URL(string: articlePath),
            imageURL: URL(string: imagePath)
        )
    }  

    init(from rssItem: RSSItem) {
        self.init(
            title: rssItem.title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            description: rssItem.description,
            publicationDate: rssItem.publicationDate ?? .now,
            url: URL(string: rssItem.link ?? ""),
            imageURL: nil
        )
    }
}

extension Article {
    static let samples =  [
        Article(
            title: "Sample Article 1",
            description: "Description for Sample Article 1",
            publicationDate: Date(),
            url: URL(string: "https://example.com/article1")!,
            imageURL: nil
        ),
        Article(
            title: "Sample Article 2",
            description: "Description for Sample Article 2",
            publicationDate: Date(),
            url: URL(string: "https://example.com/article2")!,
            imageURL: nil
        ),
        Article(
            title: "Sample Article 3",
            description: "Description for Sample Article 3",
            publicationDate: Date(),
            url: URL(string: "https://example.com/article3")!,
            imageURL: nil
        )
    ]
}
