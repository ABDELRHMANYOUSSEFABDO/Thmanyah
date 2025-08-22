//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

protocol FetchHomeSectionsUseCaseType {
    func execute(page: Int?) async throws -> HomeSectionsResponse
}

struct FetchHomeSectionsUseCase: FetchHomeSectionsUseCaseType {
    private let repo: HomeRepositoryType
    init(repo: HomeRepositoryType) { self.repo = repo }
    func execute(page: Int? = nil) async throws -> HomeSectionsResponse {
        try await repo.fetchHomeSections(page: page)
    }
}
