//
//  HomeView.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    private let grid = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.bg.ignoresSafeArea()
                if vm.isLoading {
                    ScrollView { VStack(spacing: 20) { ForEach(0..<4) { _ in placeholderSection } } }
                        .redacted(reason: .placeholder)
                        .scrollIndicators(.hidden)
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .font(.brand(15))
                            .foregroundColor(AppTheme.subtle)
                            .multilineTextAlignment(.center)
                        Button("إعادة المحاولة") { 
                            Haptics.tap(); 
                            Task { await vm.load() } 
                        }
                        .font(.brand(16, weight: .semibold))
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.tag)
                    }.padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 22) {
                            ForEach(vm.sections) { section in
                                SectionHeader(title: section.title)
                                    .accessibilityIdentifier("home_section_\(section.title)")
                                sectionView(section)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .scrollIndicators(.hidden)
                    .refreshable { Haptics.tap(); await vm.load() }
                }
            }
            .navigationTitle("الرئيسية")
            .toolbarBackground(AppTheme.bg, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SearchView().environmentObject(SearchViewModel())) {
                        Image(systemName: "magnifyingglass")
                    }
                    .accessibilityIdentifier("home_nav_search")
                }
            }
        }
        .tint(AppTheme.tag)
    }

    @ViewBuilder
    private func sectionView(_ section: HomeSection) -> some View {
        switch section.layout {
        case .grid:
            LazyVGrid(columns: grid, spacing: 16) {
                ForEach(Array(section.items.enumerated()), id: \.0) { idx, item in
                    ContentCardView(item: item)
                        .accessibilityIdentifier("content_card_\(section.order)_\(idx)")
                        .onAppear { if idx == section.items.count - 1 { Task { await vm.loadMore(for: section) } } }
                }
            }
            .padding(.horizontal)

        case .carousel, .queue:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(Array(section.items.enumerated()), id: \.0) { idx, item in
                        ContentCardView(item: item)
                            .frame(width: 260)
                            .accessibilityIdentifier("content_card_\(section.order)_\(idx)")
                            .onAppear { if idx == section.items.count - 1 { Task { await vm.loadMore(for: section) } } }
                    }
                }
                .padding(.horizontal)
            }

        case .bigSquare:
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 18) {
                ForEach(Array(section.items.enumerated()), id: \.0) { idx, item in
                    ContentCardView(item: item)
                        .frame(height: 220)
                        .accessibilityIdentifier("content_card_\(section.order)_\(idx)")
                        .onAppear { if idx == section.items.count - 1 { Task { await vm.loadMore(for: section) } } }
                }
            }
            .padding(.horizontal)

        case .twoLinesGrid:
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(Array(section.items.enumerated()), id: \.0) { idx, item in
                    ContentCardView(item: item)
                        .accessibilityIdentifier("content_card_\(section.order)_\(idx)")
                        .onAppear { if idx == section.items.count - 1 { Task { await vm.loadMore(for: section) } } }
                }
            }
            .padding(.horizontal)
        }
    }

    private var placeholderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 6).fill(AppTheme.card)
                .frame(width: 160, height: 18).padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 16).fill(AppTheme.card)
                            .frame(width: 240, height: 160).shimmering(true)
                    }
                }.padding(.horizontal)
            }
        }
    }
}
