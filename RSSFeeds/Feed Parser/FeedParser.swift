//
//  FeedParser.swift
//  RSSFeeds
//
//  Created by Quentin Genevois on 29/12/2023.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    enum Feed {
        case rss(RSSFeed)
        case atom(AtomFeed)
        case unknown
    }

    enum FeedType: String {
        case rss
        case atom = "feed"
    }

    enum ParsingError: Error {
        case invalidURL
        case unknownFeedType
        case invalidFeedModel
    }

    // MARK: - Properties

    private var type: FeedType?
    private var rssfeed: RSSFeed?
    private var atomFeed: AtomFeed?

    private var path: URL = URL(string: "/")!

    // MARK: - Public Methods

    func parse(url: URL) async throws -> Feed {
        guard let response = try? await URLSession.shared.data(from: url) else {
            throw ParsingError.invalidURL
        }

        let parser = XMLParser(data: response.0)
        parser.delegate = self
        parser.parse()

        switch type {
        case .rss:
            guard let rssfeed else {
                throw ParsingError.invalidFeedModel
            }

            return .rss(rssfeed)

        case .atom:
            guard let atomFeed else {
                throw ParsingError.invalidFeedModel
            }

            return .atom(atomFeed)

        case .none:
            throw ParsingError.unknownFeedType
        }
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        path.append(path: elementName)

        guard let type else {
            type = FeedType(rawValue: elementName)
            return
        }

        switch type {
        case .rss:
            guard let rssfeed else {
                rssfeed = .init()
                return
            }

            rssfeed.map(attributeDict, for: path.absoluteString)

        case .atom:
            guard let atomFeed else {
                atomFeed = .init()
                return
            }

            atomFeed.map(attributeDict, for: path.absoluteString)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        path.deleteLastPathComponent()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch type {
        case .rss:
            rssfeed?.map(string, for: path.absoluteString)

        case .atom:
            atomFeed?.map(string, for: path.absoluteString)

        case .none:
            break
        }
    }
}
