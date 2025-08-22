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
                AppTheme.bg
                    .ignoresSafeArea(.container, edges: .top)
                
                if vm.isLoading {
                    ScrollView { VStack(spacing: 20) { ForEach(0..<4) { _ in placeholderSection } } }
                        .redacted(reason: .placeholder)
                        .scrollIndicators(.hidden)
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error).foregroundColor(AppTheme.subtle)
                        Button("Retry") { Task { await vm.load() } }
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.tag)
                    }.padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 22) {
                            ForEach(vm.sections) { section in
                                SectionHeader(title: section.title)
                                sectionView(section)
                                    .id("section_\(section.id)")
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .scrollIndicators(.hidden)
                    .refreshable { await vm.reload() }
                }
            }
            .navigationTitle("Home")
            .toolbarBackground(AppTheme.bg, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(AppTheme.tag)
        .animation(.default, value: vm.sections)
        .safeAreaBackground(AppTheme.bg, edges: .top)
    }

    @ViewBuilder
    private func sectionView(_ section: HomeSection) -> some View {
        switch section.layout {
        case .grid:
            LazyVGrid(columns: grid, spacing: 16) {
                ForEach(section.items, id: \.id) { item in
                    ContentCardView(item: item)
                        .id("\(section.id)_\(item.id)")
                        .onAppear { if item.id == section.items.last?.id {
                         //   Task { await vm.loadMore(for: section)
                         //   }
                        } }
                }
            }
            .padding(.horizontal)

        case .carousel, .queue:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(section.items, id: \.id) { item in
                        ContentCardView(item: item)
                            .frame(width: 260)
                            .id("\(section.id)_\(item.id)")
                            .onAppear { if item.id == section.items.last?.id {
                             //   Task { await vm.loadMore(for: section)
                               // }
                            } }
                    }
                }
                .padding(.horizontal)
            }

        case .bigSquare:
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 18) {
                ForEach(section.items, id: \.id) { item in
                    ContentCardView(item: item)
                        .frame(height: 220)
                        .id("\(section.id)_\(item.id)")
                        .onAppear { if item.id == section.items.last?.id {
                           // Task { await vm.loadMore(for: section)
                            //   }
                        } }
                }
            }
            .padding(.horizontal)

        case .twoLinesGrid:
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(section.items, id: \.id) { item in
                    ContentCardView(item: item)
                        .id("\(section.id)_\(item.id)")
                        .onAppear { if item.id == section.items.last?.id {
                            //  Task { await vm.loadMore(for: section)
                      //  }
                        } }
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
                            .frame(width: 240, height: 160)
                    }
                }.padding(.horizontal)
            }
        }
    }
}
