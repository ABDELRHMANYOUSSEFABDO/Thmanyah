//
//  BrandFont.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI
import UIKit

enum BrandFontWeight {
    case regular, medium, semibold, bold
}

extension Font {
    static func brand(_ size: CGFloat, weight: BrandFontWeight = .regular) -> Font {
        switch weight {
        case .regular: return .custom("IBMPlexSansArabic-Regular", size: size)
        case .medium: return .custom("IBMPlexSansArabic-Medium", size: size)
        case .semibold: return .custom("IBMPlexSansArabic-SemiBold", size: size)
        case .bold: return .custom("IBMPlexSansArabic-Bold", size: size)
        }
    }
}

// MARK: - UIKit Support
extension UIFont {
    static func brand(_ size: CGFloat, weight: BrandFontWeight = .regular) -> UIFont? {
        switch weight {
        case .regular: return UIFont(name: "IBMPlexSansArabic-Regular", size: size)
        case .medium: return UIFont(name: "IBMPlexSansArabic-Medium", size: size)
        case .semibold: return UIFont(name: "IBMPlexSansArabic-SemiBold", size: size)
        case .bold: return UIFont(name: "IBMPlexSansArabic-Bold", size: size)
        }
    }
}
