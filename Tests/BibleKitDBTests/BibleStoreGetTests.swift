@testable import BibleKitDB
import Testing

final class BibleStoreGetTests {
    @Test
    func getVersesByIds() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        let ids = [
            "1:1:2",
            "1:1:4",
            "1:1:6",
        ]

        let verses = try await store.getVerses(
            verseIDs: ids,
            limit: Int.max,
            offset: 0
        )

        #expect(verses.map(\.id) == ids)
    }

    @Test
    func pagination() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        let ids = [
            "1:1:1",
            "1:1:2",
            "1:1:3",
            "1:1:4",
            "1:1:5",
            "1:1:6",
        ]

        // Test with limit
        let limitedVerses = try await store.getVerses(
            verseIDs: ids,
            limit: 3,
            offset: 0
        )
        #expect(limitedVerses.map(\.id) == Array(ids.prefix(3)))

        // Test with offset
        let offsetVerses = try await store.getVerses(
            verseIDs: ids,
            limit: Int.max,
            offset: 3
        )
        #expect(offsetVerses.map(\.id) == Array(ids.dropFirst(3)))

        // Test with both limit and offset
        let paginatedVerses = try await store.getVerses(
            verseIDs: ids,
            limit: 2,
            offset: 2
        )
        #expect(paginatedVerses.map(\.id) == Array(ids.dropFirst(2).prefix(2)))
    }

    @Test
    func testGetVersesInRange() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        let verses = try await store.getVersesInRange(
            startVerse: "1:1:2",
            endVerse: "43:3:19",
            limit: Int.max,
            offset: 0
        )

        let expectedVerses = Array(TestData.allVerses.dropFirst(1).dropLast(2))
        #expect(verses == expectedVerses)
    }

    @Test
    func getVersesInRangePagination() async throws {
        let repository = try await VerseDataSource.create()
        try await repository.insertVerses(TestData.allVerses)
        let store = BibleStoreProvider(repository: repository)

        // Test with limit
        let limitedVerses = try await store.getVersesInRange(
            startVerse: "1:1:1",
            endVerse: "43:3:19",
            limit: 3,
            offset: 0
        )
        #expect(limitedVerses.map(\.id) == ["1:1:1", "1:1:2", "1:1:3"])

        // Test with offset to get verses from John
        let offsetVerses = try await store.getVersesInRange(
            startVerse: "43:3:16",
            endVerse: "43:3:19",
            limit: Int.max,
            offset: 0
        )
        #expect(offsetVerses.map(\.id) == ["43:3:16", "43:3:17", "43:3:18", "43:3:19"])

        // Test with both limit and offset in John
        let paginatedVerses = try await store.getVersesInRange(
            startVerse: "43:3:16",
            endVerse: "43:3:19",
            limit: 2,
            offset: 1
        )
        #expect(paginatedVerses.map(\.id) == ["43:3:17", "43:3:18"])
    }
}
