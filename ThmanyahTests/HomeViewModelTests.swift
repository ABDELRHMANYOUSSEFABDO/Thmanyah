//
//  HomeViewModelTests.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import XCTest
@testable import Thmanyah

@MainActor
final class HomeViewModelTests: XCTestCase {
    func test_load_setsSections() async throws {
        let usecase = MockFetchHomeSectionsUseCase()
        usecase.stub = .oneSectionThreeItems
        let vm = HomeViewModel(fetchUseCase: usecase)
        await vm.load()
        XCTAssertFalse(vm.sections.isEmpty)
        XCTAssertEqual(vm.sections.first?.title, "Top Podcasts")
    }

    func test_loadMore_appendsWithoutDuplicates() async throws {
        let usecase = MockFetchHomeSectionsUseCase()
        usecase.stub = .twoPagesSameSection
        let vm = HomeViewModel(fetchUseCase: usecase)
        await vm.load()
        let firstCount = vm.sections.first?.items.count ?? 0
        await vm.loadMore(for: vm.sections.first!)
        let secondCount = vm.sections.first?.items.count ?? 0
        XCTAssertGreaterThan(secondCount, firstCount)
        let ids = vm.sections.first!.items.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }
}

final class MockFetchHomeSectionsUseCase: FetchHomeSectionsUseCaseType {
    enum Stub { case oneSectionThreeItems, twoPagesSameSection }
    var stub: Stub = .oneSectionThreeItems
    private var page = 0

    func execute(page: Int? = nil) async throws -> HomeSectionsResponse {
        let currentPage = page ?? 1
        if currentPage == 1 { self.page = 1 } else { self.page += 1 }

        switch stub {
        case .oneSectionThreeItems:
            let section = try JSONDecoder().decode(HomeSection.self, from: TestData.sectionJSON)
            return HomeSectionsResponse(sections: [section], pagination: nil)
        case .twoPagesSameSection:
            let s1 = try JSONDecoder().decode(HomeSection.self, from: TestData.sectionJSON)
            let newItem = ContentItem(id: "C", title: "C", subtitle: "d", imageURL: nil, episodeCount: 0, duration: 0, score: nil)
            let s2 = HomeSection(title: s1.title, layout: s1.layout, order: s1.order, items: s1.items + [newItem])
            return currentPage == 1
            ? HomeSectionsResponse(sections: [s1], pagination: Pagination(nextPage: "/?page=2", totalPages: 2))
            : HomeSectionsResponse(sections: [s2], pagination: Pagination(nextPage: nil, totalPages: 2))
        }
    }
}
