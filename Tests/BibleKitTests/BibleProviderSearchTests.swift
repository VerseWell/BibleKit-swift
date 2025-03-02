@testable import BibleKit
import Testing

/// Test class for BibleProvider's search functionality
/// Tests different search scenarios using mock Bible store
struct BibleProviderSearchTests {
    /// Tests searching verses with text only (no verse IDs)
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search for verses containing specific text
    /// 3. Verify search parameters are correctly passed to store
    @Test func searchWithTextOnly() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let searchText = "God"

        let verses = try await provider.search(
            query: searchText,
            verseIDs: nil,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == searchText)
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        #expect(await mockStore.limit == 10)
        #expect(await mockStore.offset == 0)
    }

    /// Tests searching verses with default limit and offset values
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search for verses without specifying limit and offset
    /// 3. Verify default pagination values are correctly used
    @Test func searchWithDefaultLimitAndOffset() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let searchText = "God"

        let verses = try await provider.search(
            query: searchText,
            verseIDs: nil
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == searchText)
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        // Verify default values
        #expect(await mockStore.limit == Int.max)
        #expect(await mockStore.offset == Int.min)
    }

    /// Tests searching verses with text and specific verse IDs
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search for verses containing text within specific verse IDs
    /// 3. Verify search parameters are correctly passed to store
    @Test func searchWithTextAndVerseIds() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let searchText = "God"
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:2"),
            VerseID(value: "1:1:3"),
        ]

        let verses = try await provider.search(
            query: searchText,
            verseIDs: verseIds,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == searchText)
        #expect(await mockStore.verseIDs == verseIds)
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        #expect(await mockStore.limit == 10)
        #expect(await mockStore.offset == 0)
    }

    /// Tests searching verses with text and reference range
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search for verses containing text within reference range
    /// 3. Verify search parameters are correctly passed to store
    @Test func searchWithTextAndReference() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let searchText = "God"
        let reference = Reference(
            from: VerseReference.fromVerseID("1:1:1")!,
            to: VerseReference.fromVerseID("1:1:10")!
        )

        let verses = try await provider.search(
            query: searchText,
            reference: reference,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == searchText)
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == VerseID(value: "1:1:1"))
        #expect(await mockStore.endVerseID == VerseID(value: "1:1:10"))
        #expect(await mockStore.limit == 10)
        #expect(await mockStore.offset == 0)
    }

    /// Tests searching verses with text and reference that requires fixup
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search for verses with reference where end comes before start
    /// 3. Verify reference is fixed up before searching
    @Test func searchWithTextAndReferenceFixup() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let searchText = "God"
        let reference = Reference(
            from: VerseReference.fromVerseID("1:1:10")!, // End comes before start
            to: VerseReference.fromVerseID("1:1:1")!
        )

        let verses = try await provider.search(
            query: searchText,
            reference: reference,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == searchText)
        #expect(await mockStore.verseIDs == nil)
        // After fixup, start should be before end
        #expect(await mockStore.startVerseID == VerseID(value: "1:1:1"))
        #expect(await mockStore.endVerseID == VerseID(value: "1:1:10"))
        #expect(await mockStore.limit == 10)
        #expect(await mockStore.offset == 0)
    }

    /// Tests searching with empty text and verse IDs
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search with empty text and verse IDs
    /// 3. Verify empty results are returned without calling store
    @Test func emptySearchWithVerseIds() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:2"),
            VerseID(value: "1:1:3"),
        ]

        let verses = try await provider.search(
            query: "", // Empty search text
            verseIDs: verseIds,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil) // Store should not be called
        #expect(await mockStore.verseIDs == nil) // Store should not be called
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        #expect(await mockStore.limit == nil) // Store should not be called
        #expect(await mockStore.offset == nil) // Store should not be called
    }

    /// Tests searching with empty text and reference range
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Search with empty text and reference range
    /// 3. Verify empty results are returned without calling store
    @Test func emptySearchWithReference() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let reference = Reference(
            from: VerseReference.fromVerseID("1:1:1")!,
            to: VerseReference.fromVerseID("1:1:10")!
        )

        let verses = try await provider.search(
            query: "   ", // Whitespace-only search text
            reference: reference,
            limit: 10,
            offset: 0
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil) // Store should not be called
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == nil) // Store should not be called
        #expect(await mockStore.endVerseID == nil) // Store should not be called
        #expect(await mockStore.limit == nil) // Store should not be called
        #expect(await mockStore.offset == nil) // Store should not be called
    }
}
