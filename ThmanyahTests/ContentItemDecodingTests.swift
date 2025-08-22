//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import XCTest
@testable import Thmanyah

final class ContentItemDecodingTests: XCTestCase {

    func test_decode_podcastItem_setsFields() throws {
        let item = try JSONDecoder().decode(ContentItem.self, from: TestData.podcastItemJSON)
        XCTAssertEqual(item.title, "The Big Listen")
        XCTAssertEqual(item.subtitle, "desc")
    }

    func test_decode_episodeItem() throws {
        let item = try JSONDecoder().decode(ContentItem.self, from: TestData.episodeItemJSON)
        XCTAssertEqual(item.title, "Episode 1")
    }
}
