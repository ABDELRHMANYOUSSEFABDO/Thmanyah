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
        case .transport(let e): return "خطأ في الشبكة: \(e.localizedDescription)"
        case .invalidResponse: return "استجابة خادم غير صالحة"
        case .status(let code, _): return "خطأ HTTP: \(code)"
        case .decoding(let e): return "خطأ في فك الترميز: \(e.localizedDescription)"
        }
    }
}
