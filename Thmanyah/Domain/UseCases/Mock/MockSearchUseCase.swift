//
//  MockSearchUseCase.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import Foundation

// Alias for the existing mock
typealias MockSearchContentUseCase = MockSearchUseCase

final class MockSearchRepository: SearchRepositoryType {
    func search(query: String, page: Int?) async throws -> SearchResponse {
        let mockUseCase = MockSearchUseCase()
        return try await mockUseCase.execute(query: query, page: page)
    }
}

final class MockNetworkClient: NetworkClient {
    func send<T: Decodable>(_ request: RequestConvertible, decoder: JSONDecoder) async throws -> T {
        // For UI tests, we'll return empty results
        if T.self == SearchResponse.self {
            return SearchResponse(results: []) as! T
        }
        if T.self == HomeSectionsResponse.self {
            return HomeSectionsResponse(sections: [], pagination: nil) as! T
        }
        fatalError("Mock not implemented for type: \(T.self)")
    }
}

final class MockHomeRepository: HomeRepositoryType {
    func fetchHomeSections(page: Int?) async throws -> HomeSectionsResponse {
        let mockUseCase = MockFetchHomeSectionsUseCase()
        return try await mockUseCase.execute(page: page)
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
            let mockItems = [
                ContentItem(id: "A", title: "Top Podcasts", subtitle: "Best podcasts", imageURL: nil, episodeCount: 10, duration: 300, score: nil),
                ContentItem(id: "B", title: "Second Podcast", subtitle: "Another great one", imageURL: nil, episodeCount: 5, duration: 250, score: nil)
            ]
            let section = HomeSection(title: "Top Podcasts", layout: .grid, order: 1, items: mockItems)
            return HomeSectionsResponse(sections: [section], pagination: nil)
        case .twoPagesSameSection:
            let mockItems = [
                ContentItem(id: "A", title: "Top Podcasts", subtitle: "Best podcasts", imageURL: nil, episodeCount: 10, duration: 300, score: nil),
                ContentItem(id: "B", title: "Second Podcast", subtitle: "Another great one", imageURL: nil, episodeCount: 5, duration: 250, score: nil)
            ]
            let s1 = HomeSection(title: "Top Podcasts", layout: .grid, order: 1, items: mockItems)
            let newItem = ContentItem(id: "C", title: "Third Podcast", subtitle: "Additional content", imageURL: nil, episodeCount: 3, duration: 200, score: nil)
            let s2 = HomeSection(title: s1.title, layout: s1.layout, order: s1.order, items: s1.items + [newItem])
            return currentPage == 1
            ? HomeSectionsResponse(sections: [s1], pagination: Pagination(nextPage: "/?page=2", totalPages: 2))
            : HomeSectionsResponse(sections: [s2], pagination: Pagination(nextPage: nil, totalPages: 2))
        }
    }
}

final class MockSearchUseCase: SearchContentUseCaseType {
    func execute(query: String, page: Int? = nil) async throws -> SearchResponse {
        // Return mock search results for UI testing
        let mockItems = [
            ContentItem(id: "search_1", title: "NPR Podcast", subtitle: "National Public Radio content", imageURL: nil, episodeCount: 15, duration: 450, score: nil),
            ContentItem(id: "search_2", title: "News Roundup", subtitle: "Daily news summary", imageURL: nil, episodeCount: 8, duration: 300, score: nil)
        ]
        return SearchResponse(results: mockItems)
    }
}
