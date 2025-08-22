//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

struct HomeSectionsRequest: RequestConvertible {
    var page: Int?
    var url: URL { URL(string: "/home_sections", relativeTo: AppConfig.apiBaseURL)! }
    var method: HTTPMethod { .GET }
    var query: [URLQueryItem] { page.map { [URLQueryItem(name: "page", value: String($0))] } ?? [] }
}

struct SearchRequest: RequestConvertible {
    let q: String; var page: Int?
    var url: URL { URL(string: "m1/735111-711675-default/search", relativeTo: AppConfig.searchBaseURL)! }
    var method: HTTPMethod { .GET }
    var query: [URLQueryItem] {
        var a = [URLQueryItem(name: "q", value: q)]
        if let p = page { a.append(.init(name: "page", value: String(p))) }
        return a
    }
}
