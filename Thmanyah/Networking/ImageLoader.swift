//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//
import SwiftUI
import UIKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: Image?
    @Published var isLoading = false
    
    private var task: Task<Void, Never>?
    private static var imageCache: [URL: Image] = [:]
    private var currentURL: URL?
    
    func load(from url: URL?) {
        guard let url = url, currentURL != url else { return }
        
        task?.cancel()
        currentURL = url
        
        if let cachedImage = Self.imageCache[url] {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        isLoading = true
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if Task.isCancelled { return }
                if let ui = UIImage(data: data) {
                    let swiftUIImage = Image(uiImage: ui)
                    
                    Self.imageCache[url] = swiftUIImage
                    
                    if !Task.isCancelled && currentURL == url {
                        self.image = swiftUIImage
                        self.isLoading = false
                    }
                }
            } catch { 
                if !Task.isCancelled && currentURL == url {
                    self.isLoading = false
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        currentURL = nil
    }
    
    static func clearCache() {
        imageCache.removeAll()
    }
}

@MainActor
final class UIImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private var task: Task<Void, Never>?
    private static var imageCache: [URL: UIImage] = [:]
    private var currentURL: URL?
    
    func load(from url: URL?) {
        guard let url = url, currentURL != url else { return }
        
        task?.cancel()
        currentURL = url
        
        if let cachedImage = Self.imageCache[url] {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        isLoading = true
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if Task.isCancelled { return }
                if let ui = UIImage(data: data) {
                    Self.imageCache[url] = ui
                    
                    if !Task.isCancelled && currentURL == url {
                        self.image = ui
                        self.isLoading = false
                    }
                }
            } catch { 
                if !Task.isCancelled && currentURL == url {
                    self.isLoading = false
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        currentURL = nil
    }
    
    static func clearCache() {
        imageCache.removeAll()
    }
}
