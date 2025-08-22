//
//  TestData.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import Foundation

enum TestData {
    static let podcastItemJSON = """
    { "podcast_id":"1079968336", "name":"The Big Listen", "description":"desc", "avatar_url":"https://example.com/p.png", "episode_count":90, "duration":266195, "language":"en" }
    """.data(using: .utf8)!

    static let episodeItemJSON = """
    { "episode_id":"e1", "name":"Episode 1", "description":"ep", "avatar_url":"https://example.com/e.png", "duration":300 }
    """.data(using: .utf8)!

    static let sectionJSON = """
    {
      "name": "Top Podcasts",
      "type": "square",
      "content_type":"podcast",
      "order": 1,
      "content": [
        { "podcast_id":"A", "name":"A", "description":"d", "avatar_url":"https://a", "episode_count":10, "duration":300 },
        { "podcast_id":"A", "name":"A-dup", "description":"d", "avatar_url":"https://a", "episode_count":10, "duration":300 },
        { "podcast_id":"B", "name":"B", "description":"d", "avatar_url":"https://b", "episode_count":15, "duration":600 }
      ]
    }
    """.data(using: .utf8)!

    static func homeResponseJSON(sections: [String]) -> Data {
        let body = """
        { "sections": [ \(sections.joined(separator: ",")) ], "pagination": { "page": 1, "total_pages": 1, "next_page": null } }
        """
        return body.data(using: .utf8)!
    }
}
