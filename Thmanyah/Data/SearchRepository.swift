//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation



struct SearchResponse: Decodable {
    let results: [ContentItem]

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let sections = try? container.decode([SearchSection].self, forKey: .sections) {
                var allContentItems: [ContentItem] = []
                for section in sections {
                    allContentItems.append(contentsOf: section.content)
                }
                results = allContentItems
                return
            }
        } catch { }
        do {
            let sections = try decoder.singleValueContainer().decode([SearchSection].self)
            var allContentItems: [ContentItem] = []
            for section in sections {
                allContentItems.append(contentsOf: section.content)
            }
            results = allContentItems
            return
        } catch {
        }
        results = []
    }
    
    private enum CodingKeys: String, CodingKey { 
        case sections 
    }
}

struct SearchSection: Decodable {
    let name: String
    let type: String
    let contentType: String
    let order: String
    let content: [ContentItem]
    
    enum CodingKeys: String, CodingKey {
        case name, type, content, order
        case contentType = "content_type"
    }
}

protocol SearchRepositoryType {
    func search(query: String, page: Int?) async throws -> SearchResponse
}

struct SearchRepository: SearchRepositoryType {
    let client: NetworkClient

    init(client: NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func search(query: String, page: Int? = nil) async throws -> SearchResponse {
        try await client.send(SearchRequest(q: query, page: page), decoder: .flexible)
    }
}
