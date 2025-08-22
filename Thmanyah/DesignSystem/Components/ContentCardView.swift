//
//  ContentCardView.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

struct ContentCardView: View, Equatable {
    let item: ContentItem
    @State private var pressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                RemoteImage(url: item.imageURL, height: 180)
                    .id("image_\(item.id)")
                LinearGradient(colors: [.clear, .black.opacity(0.55)],
                               startPoint: .top, endPoint: .bottom)
                    .cornerRadius(16)
                VStack(alignment: .leading, spacing: 6) {
                        Text(item.title).font(AppTheme.font(16, weight: .semibold))
                            .foregroundColor(.white).lineLimit(2)
                            .shadow(radius: 4)
                }
                .padding(12)
            }

            if let subtitle = item.subtitle {
                Text(subtitle.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                    .font(AppTheme.font(13))
                    .foregroundColor(AppTheme.subtle)
                    .lineLimit(2)
            }
        }
        .scaleEffect(pressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: pressed)
        .onTapGesture { Haptics.tap(); pressed = true; DispatchQueue.main.asyncAfter(deadline:.now()+0.12){ pressed=false } }
    }
    
    static func == (lhs: ContentCardView, rhs: ContentCardView) -> Bool {
        return lhs.item.id == rhs.item.id
    }
}


extension String {
    func plainHTML() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }
}
