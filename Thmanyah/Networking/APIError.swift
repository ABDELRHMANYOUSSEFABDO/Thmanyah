//
//  APIError.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
import Foundation

enum APIError: Error, LocalizedError {
    case transport(Error)
    case invalidResponse
    case status(Int, Data?)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .transport(let e): return "Network error: \(e.localizedDescription)"
        case .invalidResponse: return "Invalid server response"
        case .status(let code, _): return "HTTP Status: \(code)"
        case .decoding(let e): return "Decoding error: \(e.localizedDescription)"
        }
    }
}
