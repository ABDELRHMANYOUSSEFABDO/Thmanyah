//
//  ThmanyahUITests.swift
//  ThmanyahUITests
//
//  Created by Macbook on 20/08/2025.
//

import XCTest

final class ThmanyahUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITEST_MOCK_API"]
        app.launch()
    }

    func test_home_loads_and_search() {
        XCTAssertTrue(app.navigationBars["الرئيسية"].waitForExistence(timeout: 5))

        XCTAssertTrue(app.staticTexts["home_section_Top Podcasts"].waitForExistence(timeout: 5))

        let searchButton = app.buttons["home_nav_search"]
        if searchButton.waitForExistence(timeout: 2) {
            searchButton.tap()
        }

        let searchField = app.searchFields.element(boundBy: 0)
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("npr")

        let resultSection = app.staticTexts["نتائج البحث"]
        XCTAssertTrue(resultSection.waitForExistence(timeout: 5))
    }
}
