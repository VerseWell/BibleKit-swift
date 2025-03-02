import BibleKitDB

/// Mock implementation of VerseRepository for testing
/// Provides a controlled environment for testing Bible service functionality
/// Contains a fixed set of test verses from Genesis 1:1-2
actor MockVerseRepository: VerseRepository {
    var searchText: String?
    var verseIDs: [String]?
    var startVerse: String?
    var endVerse: String?
    var limit: Int?
    var offset: Int?

    func searchVerses(
        text: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        searchText = text
        self.limit = limit
        self.offset = offset
        return []
    }

    func searchVersesByIds(
        text: String,
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        searchText = text
        self.verseIDs = verseIDs
        self.limit = limit
        self.offset = offset
        return verseIDs.map { VerseEntity(id: $0, text: "Verse text here..") }
    }

    func searchVersesInRange(
        text: String,
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        searchText = text
        self.startVerse = startVerse
        self.endVerse = endVerse
        self.limit = limit
        self.offset = offset
        return [startVerse, endVerse]
            .map { VerseEntity(id: $0, text: "Verse text here..") }
    }

    func getVersesByIds(
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        self.verseIDs = verseIDs
        self.limit = limit
        self.offset = offset
        return verseIDs
            .map { VerseEntity(id: $0, text: "Verse text here..") }
    }

    func getVersesInRange(
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        self.startVerse = startVerse
        self.endVerse = endVerse
        self.limit = limit
        self.offset = offset
        return [startVerse, endVerse]
            .map { VerseEntity(id: $0, text: "Verse text here..") }
    }

    func insertVerses(_ verses: [VerseEntity]) async throws {
        // TODO: Not yet implemented
        fatalError("Not yet implemented")
    }
}
