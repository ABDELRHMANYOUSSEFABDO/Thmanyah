//
//  AppTheme.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

enum AppTheme {
    static func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let map: BrandFontWeight
        switch weight {
        case .regular: map = .regular
        case .medium:  map = .medium
        case .semibold: map = .semibold
        case .bold:    map = .bold
        default:       map = .regular
        }
        return .brand(size, weight: map)
    }

    static let accent  = Color("AccentColor", bundle: .main)
    static let bg      = Color.black
    static let card    = Color(red: 0.12, green: 0.12, blue: 0.13)
    static let text    = Color.white
    static let subtle  = Color.white.opacity(0.7)
    static let tag     = Color.yellow.opacity(0.9)
    
    // Tab Bar Colors
    static let tabBarIcon = Color.white
    static let tabBarIconSelected = Color.yellow.opacity(0.9)
    static let tabBarBackground = Color.black
    
    // Search Bar Colors
    static let searchBarBackground = Color(red: 0.15, green: 0.15, blue: 0.16)
    static let searchBarText = Color.white
    static let searchBarPlaceholder = Color.white.opacity(0.6)
}


