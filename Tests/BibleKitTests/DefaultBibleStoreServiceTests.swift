@testable import BibleKit
import BibleKitDB
import Testing

/// Test class for DefaultBibleStoreService
/// Tests the service layer's functionality using a mock provider
struct DefaultBibleStoreServiceTests {
    /// Tests retrieving verses by their IDs
    ///
    /// Steps:
    /// 1. Set up mock provider with test data
    /// 2. Create DefaultBibleStoreService with mock provider
    /// 3. Retrieve verses by IDs
    /// 4. Verify correct parameters are passed and verses are converted
    @Test func testGetVerses() async throws {
        let mockProvider = MockVerseRepository()
        let service = DefaultBibleStoreService(
            provider: BibleStoreProvider(
                repository: mockProvider
            )
        )
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:2"),
        ]

        let verses = try await service.getVerses(
            verseIDs: verseIds,
            limit: 5,
            offset: 0
        )

        // Verify parameters were correctly passed to provider
        #expect(await mockProvider.searchText == nil)
        #expect(await mockProvider.startVerse == nil)
        #expect(await mockProvider.endVerse == nil)
        #expect(await mockProvider.verseIDs == verseIds.map(\.value))
        #expect(await mockProvider.limit == 5)
        #expect(await mockProvider.offset == 0)
        #expect(
            verses == verseIds.map { Verse(id: $0, text: "Verse text here..") }
        )
    }

    /// Tests retrieving verses within a range
    ///
    /// Steps:
    /// 1. Set up mock provider with test data
    /// 2. Create DefaultBibleStoreService with mock provider
    /// 3. Retrieve verses within range
    /// 4. Verify correct parameters are passed and verses are converted
    @Test func testGetVersesInRange() async throws {
        let mockProvider = MockVerseRepository()
        let service = DefaultBibleStoreService(
            provider: BibleStoreProvider(
                repository: mockProvider
            )
        )
        let startVerseId = VerseID(value: "1:1:1")
        let endVerseId = VerseID(value: "1:1:10")

        let verses = try await service.getVersesInRange(
            startVerseID: startVerseId,
            endVerseID: endVerseId,
            limit: 10,
            offset: 5
        )

        // Verify parameters were correctly passed to provider
        #expect(await mockProvider.searchText == nil)
        #expect(await mockProvider.verseIDs == nil)
        #expect(await mockProvider.startVerse == startVerseId.value)
        #expect(await mockProvider.endVerse == endVerseId.value)
        #expect(await mockProvider.limit == 10)
        #expect(await mockProvider.offset == 5)
        #expect(
            verses == [startVerseId, endVerseId]
                .map { Verse(id: $0, text: "Verse text here..") }
        )
    }

    /// Tests searching verses with text and optional verse IDs
    ///
    /// Steps:
    /// 1. Set up mock provider with test data
    /// 2. Create DefaultBibleStoreService with mock provider
    /// 3. Search verses with text and verse IDs
    /// 4. Verify correct parameters are passed and verses are converted
    @Test func testSearchVerses() async throws {
        let mockProvider = MockVerseRepository()
        let service = DefaultBibleStoreService(
            provider: BibleStoreProvider(
                repository: mockProvider
            )
        )
        let searchText = "God"
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:2"),
        ]

        let verses = try await service.searchVerses(
            text: searchText,
            verseIDs: verseIds,
            limit: 15,
            offset: 10
        )

        // Verify parameters were correctly passed to provider
        #expect(await mockProvider.searchText == searchText)
        #expect(await mockProvider.verseIDs == verseIds.map(\.value))
        #expect(await mockProvider.startVerse == nil)
        #expect(await mockProvider.endVerse == nil)
        #expect(await mockProvider.limit == 15)
        #expect(await mockProvider.offset == 10)
        #expect(
            verses == verseIds.map { Verse(id: $0, text: "Verse text here..") }
        )
    }

    /// Tests searching verses with text only (no verse IDs)
    ///
    /// Steps:
    /// 1. Set up mock provider with test data
    /// 2. Create DefaultBibleStoreService with mock provider
    /// 3. Search verses with text only
    /// 4. Verify correct parameters are passed and verses are converted
    @Test func searchVersesWithoutIds() async throws {
        let mockProvider = MockVerseRepository()
        let service = DefaultBibleStoreService(
            provider: BibleStoreProvider(
                repository: mockProvider
            )
        )
        let searchText = "God"

        let verses = try await service.searchVerses(
            text: searchText,
            verseIDs: nil,
            limit: 20,
            offset: 15
        )

        // Verify parameters were correctly passed to provider
        #expect(await mockProvider.searchText == searchText)
        #expect(await mockProvider.verseIDs == nil)
        #expect(await mockProvider.startVerse == nil)
        #expect(await mockProvider.endVerse == nil)
        #expect(await mockProvider.limit == 20)
        #expect(await mockProvider.offset == 15)
        #expect(verses.isEmpty)
    }

    /// Tests searching verses within a range
    ///
    /// Steps:
    /// 1. Set up mock provider with test data
    /// 2. Create DefaultBibleStoreService with mock provider
    /// 3. Search verses with text within range
    /// 4. Verify correct parameters are passed and verses are converted
    @Test func testSearchVersesInRange() async throws {
        let mockProvider = MockVerseRepository()
        let service = DefaultBibleStoreService(
            provider: BibleStoreProvider(
                repository: mockProvider
            )
        )
        let searchText = "God"
        let startVerseId = VerseID(value: "1:1:1")
        let endVerseId = VerseID(value: "1:1:10")

        let verses = try await service.searchVersesInRange(
            text: searchText,
            startVerseID: startVerseId,
            endVerseID: endVerseId,
            limit: 25,
            offset: 20
        )

        // Verify parameters were correctly passed to provider
        #expect(await mockProvider.searchText == searchText)
        #expect(await mockProvider.verseIDs == nil)
        #expect(await mockProvider.startVerse == startVerseId.value)
        #expect(await mockProvider.endVerse == endVerseId.value)
        #expect(await mockProvider.limit == 25)
        #expect(await mockProvider.offset == 20)
        #expect(
            verses == [startVerseId, endVerseId]
                .map { Verse(id: $0, text: "Verse text here..") }
        )
    }
}
