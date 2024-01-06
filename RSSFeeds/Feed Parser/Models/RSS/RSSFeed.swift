//
//  RSSFeed.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 29/12/2023.
//

import Foundation

/// https://www.rssboard.org/rss-specification
final class RSSFeed {
    private enum Path: String {
        case item = "/rss/channel/item"
        case itemTitle = "/rss/channel/item/title"
        case itemDescription = "/rss/channel/item/description"
        case itemLink = "/rss/channel/item/link"
        case itemPubDate = "/rss/channel/item/pubDate"
    }

    // MARK: - Properties

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()

    var items: [RSSItem] = []

    // MARK: - Public Methods

    func map(_ attributes: [String: String], for path: String) {
        switch Path(rawValue: path) {
        case .item:
            items.append(RSSItem())

        default: 
            break
        }
    }

    func map(_ string: String, for path: String) {
        guard let lastItem = items.last else {
            return
        }

        switch Path(rawValue: path) {
        case .itemTitle:
            lastItem.title = (lastItem.title ?? "").appending(string)

        case .itemDescription:
            lastItem.description = (lastItem.description ?? "").appending(string)

        case .itemLink:
            lastItem.link = (lastItem.link ?? "").appending(string)

        case .itemPubDate:
            lastItem.publicationDate = Self.formatter.date(from: string)

        default:
            break
        }
    }
}
