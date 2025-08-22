//
//  HomeSectionDecodingTests.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import XCTest
@testable import Thmanyah

final class HomeSectionDecodingTests: XCTestCase {
    func test_section_layout_maps_square_to_grid() throws {
        let section = try JSONDecoder().decode(HomeSection.self, from: TestData.sectionJSON)
        XCTAssertEqual(section.layout, .grid)
        XCTAssertEqual(section.order, 1)
        XCTAssertEqual(section.items.count, 3)
    }

}
