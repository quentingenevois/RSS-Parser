//
//  AtomEntry.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 02/01/2024.
//

import Foundation

final class AtomEntry {
    var title: String?
    var description: String?
    var updateDate: Date?
    var links: [AtomEntryLink] = []
}
