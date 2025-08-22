//
//  AppConfig.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
import Foundation

enum AppConfig {

    static var apiBaseURL: URL {
        guard let sourceUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
              let url = URL(string: sourceUrl) else {
            fatalError("❌ API_BASE_URL")
        }
        return url
    }
    static var searchBaseURL: URL {
        guard let sourceUrl = Bundle.main.object(forInfoDictionaryKey: "SEARCH_BASE_URL") as? String,
              let url = URL(string: sourceUrl) else {
            fatalError("❌ API_BASE_URL")
        }
        return url
    }
}
