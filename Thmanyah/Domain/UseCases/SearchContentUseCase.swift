//
//  SearchContentUseCase.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

protocol SearchContentUseCaseType {
    func execute(query: String, page: Int?) async throws -> SearchResponse
}

struct SearchContentUseCase: SearchContentUseCaseType {
    private let repo: SearchRepositoryType
    init(repo: SearchRepositoryType) { self.repo = repo }
    func execute(query: String, page: Int? = nil) async throws -> SearchResponse {
        try await repo.search(query: query, page: page)
    }
}
