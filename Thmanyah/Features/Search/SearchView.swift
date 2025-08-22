//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 22/08/2025.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var vm: SearchViewModel

    private let grid = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            if vm.isSearching {
                ProgressView().padding()
            }
            if let error = vm.errorMessage {
                Text(error)
                    .font(.brand(16))
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            if !vm.results.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("نتائج البحث")
                        .font(.brand(20, weight: .semibold))
                        .foregroundColor(.primary)
                        .accessibilityIdentifier("نتائج البحث")
                    
                    LazyVGrid(columns: grid, spacing: 16) {
                        ForEach(Array(vm.results.enumerated()), id: \.1.id) { idx, item in
                            ContentCardView(item: item)
                                .accessibilityIdentifier("search_card_\(idx)")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            } else if !vm.query.isEmpty && !vm.isSearching {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("لا توجد نتائج")
                        .font(.brand(24, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text("جرب البحث بكلمات مختلفة")
                        .font(.brand(16))
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("بحث")
        .searchable(text: $vm.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "إبحث عن بودكاست، حلقات...")
    }
}
