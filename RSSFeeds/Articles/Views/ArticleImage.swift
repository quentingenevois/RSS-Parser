//
//  ArticleImage.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 04/01/2024.
//

import SwiftUI

struct ArticleImage: View {
    // MARK: - Properties

    let url: URL?

    // MARK: - Body

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image): // Loaded Image
                image
                    .resizable()

            case .failure: // Error
                placeholderImage(systemName: "exclamationmark.triangle.fill")

            case .empty where url != nil: // Empty phase with image URL, aka in progress
                ProgressView()

            default: // Placeholder
                placeholderImage(systemName: "newspaper")
            }
        }
        .scaledToFill()
        .frame(width: 85, height: 85)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }

    // MARK: - Private Methods

    private func placeholderImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .padding()
            .foregroundColor(.secondary)
            .imageScale(.large)
    }
}

#Preview("Empty URL", traits: .sizeThatFitsLayout) {
    ArticleImage(url: nil)
}


#Preview("Invalid Image", traits: .sizeThatFitsLayout) {
    ArticleImage(url: URL(string: "./foo"))
}


#Preview("Valid Image", traits: .sizeThatFitsLayout) {
    ArticleImage(url: URL(string: "https://www.example.com/image.png"))
}
