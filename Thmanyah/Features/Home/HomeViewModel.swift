import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var sections: [HomeSection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var currentPage = 1
    private var totalPages = 1
    private var nextPagePath: String? = nil
    private var isLoadingMore = false

    private let fetchUseCase: FetchHomeSectionsUseCaseType

    init(fetchUseCase: FetchHomeSectionsUseCaseType = DI.makeFetchHomeSections()) {
        self.fetchUseCase = fetchUseCase
        Task { await load() }
    }

    func load() async { await fetchPage(1, reset: true) }
    func reload() async { await fetchPage(1, reset: true) }

    func loadMore(for _: HomeSection) async {
        guard !isLoadingMore, currentPage < totalPages else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        await fetchPage(currentPage + 1, reset: false)
    }

    private func fetchPage(_ page: Int, reset: Bool) async {
        do {
            if reset { errorMessage = nil; isLoading = true }
            defer { if reset { isLoading = false } }

            let res = try await fetchUseCase.execute(page: page)
            currentPage = page
            totalPages = res.pagination?.totalPages ?? 1
            nextPagePath = res.pagination?.nextPage

            if reset {
                sections = res.sections
            } else {
                sections = Self.merge(existing: sections, with: res.sections)
            }
        } catch {
            if reset { errorMessage = "Unable to load content. Try again."}
        }
    }

    private static func merge(existing: [HomeSection], with incoming: [HomeSection]) -> [HomeSection] {
        var map = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
        for sec in incoming {
            if var old = map[sec.id] {
                let oldIDs = Set(old.items.map(\.id))
                let newOnes = sec.items.filter { !oldIDs.contains($0.id) }
                old = HomeSection(title: old.title, layout: old.layout, order: old.order, items: old.items + newOnes)
                map[sec.id] = old
            } else {
                map[sec.id] = sec
            }
        }
        return map.values.sorted { $0.order < $1.order }
    }
}
