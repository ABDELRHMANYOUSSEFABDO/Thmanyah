//
//  SafeAreaHelper.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI
import UIKit

extension View {
    func safeAreaBackground(_ color: Color, edges: Edge.Set = .all) -> some View {
        ZStack {
            color
                .ignoresSafeArea(.container, edges: edges)
            self
        }
    }
    
    func contentBackground(_ color: Color) -> some View {
        self.background(color)
    }
}

struct SafeAreaHelper {
    static func getSafeAreaInsets() -> UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
    
    static var hasDynamicIsland: Bool {
        if #available(iOS 16.0, *) {
            return UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.keyWindow?.safeAreaInsets.top ?? 0 > 47
        }
        return false
    }
    
    static var statusBarHeight: CGFloat {
        getSafeAreaInsets().top
    }
    
    static var homeIndicatorHeight: CGFloat {
        getSafeAreaInsets().bottom
    }
}

extension Color {
    func safeAreaBackground(edges: Edge.Set = .all) -> some View {
        self.ignoresSafeArea(.container, edges: edges)
    }
    
    func contentBackground() -> some View {
        self.background(self)
    }
}
