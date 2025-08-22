//
//  TagCapsule.swift
//  Thmanyah
//
//  Created by Macbook on 21/08/2025.
//
import SwiftUI
struct TagCapsule: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.brand(11, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(AppTheme.tag).clipShape(Capsule())
    }
}
