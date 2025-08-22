//
//  NetworkClientTests.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import XCTest
@testable import Thmanyah



final class NetworkClientTests: XCTestCase {
    func test_buildsURLWithQuery() async throws {
        let client = URLSessionNetworkClient(session: .mocked())
        let request = HomeSectionsRequest(page: 2)
        let _: HomeSectionsResponse = try await client.send(request)
        let last = MockURLProtocol.lastRequest
        XCTAssertNotNil(last)
        XCTAssertEqual(last?.httpMethod, "GET")
        let expectedURL = AppConfig.apiBaseURL.appendingPathComponent("home_sections").appendingQueryItem(name: "page", value: "2")
        XCTAssertEqual(last?.url?.absoluteString, expectedURL.absoluteString)
    }
}

extension URLSession {
     static func mocked() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}

final class MockURLProtocol: URLProtocol {
    static var lastRequest: URLRequest?
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        Self.lastRequest = request
        let data = #"{"sections":[]}"#.data(using: .utf8)!
        let resp = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

extension URL {
    func appendingQueryItem(name: String, value: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        components.queryItems = queryItems
        return components.url!
    }
}
