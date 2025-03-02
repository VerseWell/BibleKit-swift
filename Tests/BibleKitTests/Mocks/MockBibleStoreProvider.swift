@testable import BibleKit

/// Mock implementation of BibleStoreService for testing
/// Provides a controlled environment for testing Bible functionality
actor MockBibleStoreProvider: BibleStoreService {
    var searchText: String?
    var startVerseID: VerseID?
    var endVerseID: VerseID?
    var verseIDs: [VerseID]?
    var limit: Int?
    var offset: Int?

    func searchVerses(
        text: String,
        verseIDs: [VerseID]?,
        limit: Int,
        offset: Int
    ) async -> [Verse] {
        self.searchText = text
        self.verseIDs = verseIDs
        self.limit = limit
        self.offset = offset
        return []
    }

    func searchVersesInRange(
        text: String,
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async -> [Verse] {
        self.searchText = text
        self.startVerseID = startVerseID
        self.endVerseID = endVerseID
        self.limit = limit
        self.offset = offset
        return []
    }

    func getVerses(
        verseIDs: [VerseID],
        limit: Int,
        offset: Int
    ) async -> [Verse] {
        self.verseIDs = verseIDs
        self.limit = limit
        self.offset = offset
        return []
    }

    func getVersesInRange(
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async -> [Verse] {
        self.startVerseID = startVerseID
        self.endVerseID = endVerseID
        self.limit = limit
        self.offset = offset
        return []
    }
}
