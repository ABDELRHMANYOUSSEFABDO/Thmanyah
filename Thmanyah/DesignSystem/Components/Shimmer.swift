//
//  Shimmer.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
 
import SwiftUI
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -200
    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.25), .clear]),
                           startPoint: .leading, endPoint: .trailing)
            .rotationEffect(.degrees(20)).offset(x: phase)
            .mask(content)
        )
        .onAppear { withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) { phase = 300 } }
    }
}
extension View {
    func shimmering(_ active: Bool) -> some View {
        Group { active ? AnyView(self.modifier(Shimmer())) : AnyView(self) }
    }
}
