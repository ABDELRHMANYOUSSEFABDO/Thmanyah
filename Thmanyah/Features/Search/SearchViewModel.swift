//
//  SearchViewModel.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { onQueryChanged() }
    }
    @Published private(set) var results: [ContentItem] = []
    @Published private(set) var isSearching = false
    @Published var errorMessage: String?

    private let searchUseCase: SearchContentUseCaseType
    private let debouncer = Debouncer(milliseconds: 200)
    private var searchTask: Task<Void, Never>?

    init(searchUseCase: SearchContentUseCaseType = DI.makeSearchContent()) {
        self.searchUseCase = searchUseCase
    }

    func onQueryChanged() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            results = []; errorMessage = nil; isSearching = false
            return
        }
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            await debouncer.submit { [weak self] in
                await self?.performSearch()
            }
        }
    }

    private func performSearch() async {
        do {
            isSearching = true; errorMessage = nil
            defer { isSearching = false }
            
            let response = try await searchUseCase.execute(query: query, page: nil)
            
            withAnimation {
                self.results = response.results
            }
        } catch {
            self.errorMessage = "An error occurred while searching."

        }
    }
}
