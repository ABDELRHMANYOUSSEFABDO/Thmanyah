//
//  RemoteImage.swift
//  Thmanyah
//
//  Created by Macbook on 21/08/2025.
//

import SwiftUI

struct RemoteImage: View, Equatable {
    let url: URL?
    var height: CGFloat = 180
    
    @State private var loadedImage: Image?
    @State private var isLoading = false
    @State private var hasFailed = false
    
    private static var imageCache: [URL: Image] = [:]

    var body: some View {
        Group {
            if let image = loadedImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
            } else if isLoading {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.card)
                    .shimmering(true)
                    .frame(height: height)
            } else if hasFailed {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.card)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundColor(AppTheme.subtle)
                            Text("فشل في تحميل الصور")
                                .font(.caption2)
                                .foregroundColor(AppTheme.subtle)
                        }
                    )
                    .frame(height: height)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.card)
                    .shimmering(true)
                    .frame(height: height)
            }
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.3), radius: 10, y: 6)
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            loadImage()
        }
        .drawingGroup()
        .id(url?.absoluteString ?? "no_url")
        .allowsHitTesting(false)
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        if loadedImage != nil { return }
        
        if let cachedImage = Self.imageCache[url] {
            loadedImage = cachedImage
            return
        }
        
        isLoading = true
        hasFailed = false
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let ui = UIImage(data: data) {
                    let swiftUIImage = Image(uiImage: ui)
                    
                    Self.imageCache[url] = swiftUIImage
                    
                    await MainActor.run {
                        loadedImage = swiftUIImage
                        isLoading = false
                    }
                } else {
                    await MainActor.run {
                        hasFailed = true
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    hasFailed = true
                    isLoading = false
                }
            }
        }
    }
    
    static func == (lhs: RemoteImage, rhs: RemoteImage) -> Bool {
        return lhs.url == rhs.url && lhs.height == rhs.height
    }
}

