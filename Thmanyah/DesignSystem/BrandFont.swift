//
//  BrandFont.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

enum BrandFontWeight {
    case regular, medium, semibold, bold
}

extension Font {
    /// IBM Plex Sans Arabic mapping (update names if needed after inspecting PostScript names).
    static func brand(_ size: CGFloat, weight: BrandFontWeight = .regular) -> Font {
        switch weight {
        case .regular: return .custom("IBMPlexSansArabic-Regular", size: size)
        case .medium: return .custom("IBMPlexSansArabic-Medium", size: size)
        case .semibold: return .custom("IBMPlexSansArabic-SemiBold", size: size)
        case .bold: return .custom("IBMPlexSansArabic-Bold", size: size)
        }
    }
}
