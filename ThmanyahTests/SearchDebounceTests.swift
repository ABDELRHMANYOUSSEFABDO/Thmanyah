//
//  SearchDebounceTests.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import XCTest
@testable import Thmanyah

@MainActor
final class SearchDebounceTests: XCTestCase {
    func test_debounce_200ms_cancels_previous() async {
        let vm = SearchViewModel(searchUseCase: MockSearchUseCaseUnit())
        vm.query = "np"
        vm.query = "npr"
        try? await Task.sleep(nanoseconds: 300_000_000)
        XCTAssertEqual(vm.query, "npr")
        XCTAssertEqual(vm.results.count, 1)
    }
}

final class MockSearchUseCaseUnit: SearchContentUseCaseType {
    func execute(query: String, page: Int? = nil) async throws -> SearchResponse {
        let items = [ContentItem(id: "x", title: "X", subtitle: "desc", imageURL: nil, episodeCount: 0, duration: 0, score: nil)]
        let section = SearchSection(name: "Results", type: "square", contentType: "podcast", order: "1", content: items)
        return SearchResponse(results: items)
    }
}
