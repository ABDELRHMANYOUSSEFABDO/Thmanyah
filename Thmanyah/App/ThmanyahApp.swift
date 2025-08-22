//
//  ThmanyahApp.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

@main
struct ThmanyahApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var searchVM = SearchViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(homeVM)
                .environmentObject(searchVM)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var searchVM: SearchViewModel
    
    var body: some View {
        ZStack {
            AppTheme.bg
                .ignoresSafeArea(.container, edges: .all)
            
            TabView {
                HomeView()
                    .tabItem { 
                        Label("Home", systemImage: "square.grid.2x2")
                    }
                
                SearchUIKitWrapper(viewModel: searchVM)
                    .tabItem { 
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
            .accentColor(AppTheme.tabBarIconSelected)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(AppTheme.tabBarBackground)
                
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.tabBarIcon)
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor(AppTheme.tabBarIcon)
                ]
                
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.tabBarIconSelected)
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor(AppTheme.tabBarIconSelected)
                ]
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaBackground(AppTheme.bg, edges: .all)
    }
}

struct SearchUIKitWrapper: UIViewControllerRepresentable {
    let viewModel: SearchViewModel
    
    func makeUIViewController(context: Context) -> SearchUIKitViewController {
        return SearchUIKitViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: SearchUIKitViewController, context: Context) {}
}
