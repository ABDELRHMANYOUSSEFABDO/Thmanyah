//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

typealias HTTPHeaders = [String: String]

protocol RequestConvertible {
    var url: URL { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem] { get }
    var headers: HTTPHeaders { get }
    var body: Data? { get }
}

extension RequestConvertible {
    var headers: HTTPHeaders { [:] }
    var body: Data? { nil }
}
