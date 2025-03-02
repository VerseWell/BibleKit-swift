@testable import BibleKitDB
import Testing

final class BibleStoreSearchTests {
    @Test
    func searchAllVerses() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        let verses = try await store.searchVerses(
            text: "waters",
            verseIDs: nil,
            limit: Int.max,
            offset: 0
        )

        #expect(verses.map(\.id) == ["1:1:2", "1:1:6", "19:23:2"])
    }

    @Test
    func searchVerseRange() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        let verses = try await store.searchVersesInRange(
            text: "waters",
            startVerse: "1:1:3",
            endVerse: "19:23:3",
            limit: Int.max,
            offset: 0
        )

        #expect(verses.map(\.id) == ["1:1:6", "19:23:2"])
    }

    @Test
    func searchSpecificVerses() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.genesisVerses)
        let store = BibleStoreProvider(repository: repository)

        let ids = [
            "1:1:4",
            "1:1:5",
            "1:1:6",
        ]

        let verses = try await store.searchVerses(
            text: "God",
            verseIDs: ids,
            limit: Int.max,
            offset: 0
        )

        #expect(verses.map(\.id) == ids)
    }

    @Test
    func searchNonExistentWord() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.genesisVerses)
        let store = BibleStoreProvider(repository: repository)

        let ids = [
            "1:1:1",
            "1:1:2",
            "1:1:3",
            "1:1:4",
        ]

        let verses = try await store.searchVerses(
            text: "Inni",
            verseIDs: ids,
            limit: Int.max,
            offset: 0
        )

        #expect(verses.isEmpty)
    }

    @Test(arguments: ["GOD", "god", "GoD"])
    func searchCaseSensitivity(searchString: String) async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.genesisVerses)
        let store = BibleStoreProvider(repository: repository)

        let ids = ["1:1:1", "1:1:2", "1:1:3"]

        let results = try await store.searchVerses(
            text: searchString,
            verseIDs: ids,
            limit: Int.max,
            offset: 0
        )

        #expect(results.map(\.id) == ids)
    }
}
