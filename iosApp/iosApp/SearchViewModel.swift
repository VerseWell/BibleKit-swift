import BibleKit
import SwiftUI

@MainActor
@Observable
final class SearchViewModel {
    static let startVerse = VerseReference.fromVerseID(VerseID.start.value)!
    static let endVerse = VerseReference.fromVerseID(VerseID.end.value)!

    @ObservationIgnored
    private var activeTask: Task<Void, Never>?

    var reference: Reference = .init(
        from: SearchViewModel.startVerse,
        to: SearchViewModel.endVerse
    ) {
        didSet {
            guard reference != oldValue else { return }
            performSearch()
        }
    }

    var loadingCount: Int = 0
    var isLoading: Bool {
        loadingCount > 0
    }

    var results: [Verse] = []
    var errorMessage: String?

    var searchQuery = "" {
        didSet {
            guard searchQuery != oldValue else { return }
            performSearch()
        }
    }

    private let bibleProvider: BibleProvider

    init(bibleProvider: BibleProvider) {
        self.bibleProvider = bibleProvider
    }

    func performSearch() {
        activeTask?.cancel()
        let reference = reference
        activeTask = Task {
            if searchQuery.isEmpty {
                results = []
            } else {
                do {
                    loadingCount += 1
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
                    let searchResults = try await bibleProvider.search(
                        query: searchQuery,
                        reference: reference,
                        limit: .max,
                        offset: 0
                    )
                    try Task.checkCancellation()
                    results = searchResults
                } catch is CancellationError {
                    // No-op.
                } catch {
                    errorMessage = error.localizedDescription
                }
                loadingCount -= 1
            }
        }
    }
}
