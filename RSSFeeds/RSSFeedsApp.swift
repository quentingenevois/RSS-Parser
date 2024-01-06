//
//  RSSFeedsApp.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 29/12/2023.
//

import SwiftUI

@main
struct RSSFeedsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ArticlesListView()
                    .navigationBarTitle("Apple News")
            }
            .tint(.orange)
        }
    }
}
