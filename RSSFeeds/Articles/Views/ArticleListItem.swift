//
//  ArticleListItem.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 02/01/2024.
//

import SwiftUI

struct ArticleListItem: View {
    // MARK: - Properties

    let article: Article

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(article.title)
                    .lineLimit(3)
                    .font(.headline)

                Text(
                    article.publicationDate,
                    format: .dateTime.day().month(.wide).weekday(.short)
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            ArticleImage(url: article.imageURL)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    List {
        ArticleListItem(article: Article.samples.first!)
    }
}
