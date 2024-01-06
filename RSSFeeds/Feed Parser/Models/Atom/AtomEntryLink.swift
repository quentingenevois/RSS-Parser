//
//  AtomEntryLink.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 04/01/2024.
//

import Foundation

final class AtomEntryLink {
    let href: String?
    let title: String?
    let type: String?

    init(attributes: [String: String]) {
        href = attributes["href"]
        title = attributes["title"]
        type = attributes["type"]
    }
}
