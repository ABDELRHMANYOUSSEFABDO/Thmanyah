//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI
struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppTheme.font(22, weight: .bold))
                .foregroundColor(AppTheme.text)
                .overlay(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppTheme.tag).frame(width: 32, height: 3).offset(y: 6)
                }
            Spacer()
            if let t = actionTitle, let act = action {
                Button(t, action: { Haptics.tap(); act() })
                    .font(AppTheme.font(13, weight: .semibold))
                    .foregroundColor(AppTheme.tag)
            }
        }
        .padding(.horizontal)
    }
}
