//
//  JSONDecoder+Flexible.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

extension JSONDecoder {
    static var flexible: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        d.dateDecodingStrategy = .custom { decoder -> Date in
            let c = try decoder.singleValueContainer()
            if let ts = try? c.decode(Double.self) {
                return Date(timeIntervalSince1970: ts)
            }
            if let s = try? c.decode(String.self) {
                if let d = ISO8601DateFormatter().date(from: s) { return d }
                let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
                if let d = f.date(from: s) { return d }
            }
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid date")
        }
        return d
    }
}


