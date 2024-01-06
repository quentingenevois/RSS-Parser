//
//  AtomFeed.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 02/01/2024.
//

import Foundation

/// https://datatracker.ietf.org/doc/html/rfc4287
final class AtomFeed {
    private enum Path: String {
        case entry = "/feed/entry"
        case entryTitle = "/feed/entry/title"
        case entryContent = "/feed/entry/content"
        case entryLink = "/feed/entry/link"
        case entryUpdate = "/feed/entry/updated"
    }

    // MARK: - Properties

    private static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    var entries: [AtomEntry] = []

    // MARK: - Public Methods

    func map(_ attributes: [String: String], for path: String) {
        switch Path(rawValue: path) {
        case .entry:
            entries.append(AtomEntry())

        case .entryLink:
            entries.last?.links.append(AtomEntryLink(attributes: attributes))

        default:
            break
        }
    }

    func map(_ string: String, for path: String) {
        guard let lastEntry = entries.last else {
            return
        }

        switch Path(rawValue: path) {
        case .entryTitle:
            lastEntry.title = (lastEntry.title ?? "").appending(string)

        case .entryContent:
            lastEntry.description = (lastEntry.description ?? "").appending(string)

        case .entryUpdate:
            lastEntry.updateDate = Self.formatter.date(from: string)

        default:
            break
        }
    }
}
