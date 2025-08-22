//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation


enum SectionLayout: String, Decodable {
    case grid
    case carousel
    case queue
    case bigSquare
    case twoLinesGrid

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        switch raw {
        case "square":         self = .grid
        case "big_square":     self = .bigSquare
        case "2_lines_grid":   self = .twoLinesGrid
        case "queue":          self = .queue
        case "carousel":       self = .carousel
        default:               self = .grid
        }
    }
}

struct HomeSection: Identifiable, Decodable, Equatable {
    var id: String { title + "|" + layout.rawValue }
    let title: String
    let layout: SectionLayout
    let order: Int
    let items: [ContentItem]

    private enum CodingKeys: String, CodingKey {
        case name, type, order, content, contentType = "content_type"
    }

    init(title: String, layout: SectionLayout, order: Int, items: [ContentItem]) {
        self.title = title
        self.layout = layout
        self.order = order
        self.items = items
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let title  = try c.decode(String.self, forKey: .name)
        let layout = try c.decode(SectionLayout.self, forKey: .type)
        let order  = try c.decodeIfPresent(Int.self, forKey: .order) ?? 0

        var rawItems = try c.decode([ContentItem].self, forKey: .content)

        var seen = Set<String>()
        var fixed: [ContentItem] = []
        fixed.reserveCapacity(rawItems.count)

        for (idx, item) in rawItems.enumerated() {
            if seen.insert(item.id).inserted {
                fixed.append(item)
            } else {
                fixed.append(item.withID("\(item.id)#\(idx)"))
            }
        }

        self.init(title: title, layout: layout, order: order, items: fixed)
    }
}

struct HomeSectionsResponse: Decodable {
    let sections: [HomeSection]
    let pagination: Pagination?

    enum CodingKeys: String, CodingKey {
        case sections
        case pagination
    }
}

struct Pagination: Decodable {
    let nextPage: String?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
                
        nextPage = try? c.decode(String.self, forKey: .nextPage)
        totalPages = try? c.decode(Int.self, forKey: .totalPages)
        
    }
}

