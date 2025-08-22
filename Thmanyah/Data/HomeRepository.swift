//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//


import Foundation

protocol HomeRepositoryType {
    func fetchHomeSections(page: Int?) async throws -> HomeSectionsResponse
}

struct HomeRepository: HomeRepositoryType {
    let client: NetworkClient

    init(client: NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func fetchHomeSections(page: Int? = nil) async throws -> HomeSectionsResponse {
        let request = HomeSectionsRequest(page: page)
        let response: HomeSectionsResponse = try await client.send(request, decoder: .flexible)
        return response
    }
}

