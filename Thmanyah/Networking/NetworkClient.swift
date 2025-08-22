//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

protocol NetworkClient {
    func send<T: Decodable>(_ request: RequestConvertible, decoder: JSONDecoder ) async throws -> T
}

struct URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                   diskCapacity: 150 * 1024 * 1024,
                                   diskPath: "thmanyah-cache")
        return URLSession(configuration: config)
    }()) { self.session = session }

    func send<T: Decodable>(_ request: RequestConvertible, decoder: JSONDecoder = .flexible) async throws -> T {
        var comp = URLComponents(url: request.url, resolvingAgainstBaseURL: true)!
        if !request.query.isEmpty {
            comp.queryItems = (comp.queryItems ?? []) + request.query
        }
        var urlRequest = URLRequest(url: comp.url!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        request.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let http = response as? HTTPURLResponse else { 
                throw APIError.invalidResponse
            }
            
            guard 200..<300 ~= http.statusCode else { 
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 [NetworkClient] Error response body:", responseString)
                }
                throw APIError.status(http.statusCode, data) 
            }
            
            
            if let responseString = String(data: data, encoding: .utf8) {
            }
            
            do { 
                let result = try decoder.decode(T.self, from: data)
             
                return result
            }
            catch { 
                if let responseString = String(data: data, encoding: .utf8) {
                }
                throw APIError.decoding(error) 
            }
        } catch { 
            throw APIError.transport(error) 
        }
    }
}
