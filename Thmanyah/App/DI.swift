//
//  DI.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
import Foundation

enum DI {
    static func makeNetwork() -> NetworkClient { URLSessionNetworkClient() }

    static func makeHomeRepo() -> HomeRepositoryType { HomeRepository(client: makeNetwork()) }
    static func makeSearchRepo() -> SearchRepositoryType { SearchRepository(client: makeNetwork()) }

    static func makeFetchHomeSections() -> FetchHomeSectionsUseCaseType { FetchHomeSectionsUseCase(repo: makeHomeRepo()) }
    static func makeSearchContent() -> SearchContentUseCaseType { SearchContentUseCase(repo: makeSearchRepo()) }
}

