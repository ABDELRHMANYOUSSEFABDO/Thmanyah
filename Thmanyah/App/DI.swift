//
//  DI.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
import Foundation

enum DI {
    private static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITEST_MOCK_API")
    }
    
    static func makeNetwork() -> NetworkClient { 
        isUITesting ? MockNetworkClient() : URLSessionNetworkClient() 
    }

    static func makeHomeRepo() -> HomeRepositoryType { 
        isUITesting ? MockHomeRepository() : HomeRepository(client: makeNetwork()) 
    }
    
    static func makeSearchRepo() -> SearchRepositoryType { 
        isUITesting ? MockSearchRepository() : SearchRepository(client: makeNetwork()) 
    }

    static func makeFetchHomeSections() -> FetchHomeSectionsUseCaseType { 
        isUITesting ? MockFetchHomeSectionsUseCase() : FetchHomeSectionsUseCase(repo: makeHomeRepo()) 
    }
    
    static func makeSearchContent() -> SearchContentUseCaseType { 
        isUITesting ? MockSearchContentUseCase() : SearchContentUseCase(repo: makeSearchRepo()) 
    }
}

