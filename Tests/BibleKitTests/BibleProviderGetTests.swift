@testable import BibleKit
import Testing

/// Test class for BibleProvider
/// Tests verse and chapter retrieval functionality
/// Uses a mock Bible store for testing
struct BibleProviderGetTests {
    /// Tests verse retrieval functionality
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Retrieve verses by their IDs
    /// 3. Verify that correct verses are returned
    @Test func getVerses() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:3"),
            VerseID(value: "1:1:5"),
        ]

        let verses = try await provider.verses(
            ids: verseIds,
            limit: 3,
            offset: 2
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil)
        #expect(await mockStore.verseIDs == verseIds)
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        #expect(await mockStore.limit == 3)
        #expect(await mockStore.offset == 2)
    }

    /// Tests verse retrieval functionality with default limit and offset values
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Retrieve verses by their IDs
    /// 3. Verify default pagination values are correctly used
    @Test func getWithDefaultLimitAndOffset() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let verseIds = [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:3"),
            VerseID(value: "1:1:5"),
        ]

        let verses = try await provider.verses(ids: verseIds)

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil)
        #expect(await mockStore.verseIDs == verseIds)
        #expect(await mockStore.startVerseID == nil)
        #expect(await mockStore.endVerseID == nil)
        // Verify default values
        #expect(await mockStore.limit == Int.max)
        #expect(await mockStore.offset == Int.min)
    }

    /// Tests chapter retrieval functionality
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Retrieve verses from a specific chapter
    /// 3. Verify that correct verses are returned
    @Test func getChapter() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let chapterRef = ChapterReference(
            bookName: .Genesis,
            index: 1
        )

        let verses = try await provider.chapter(
            chapter: chapterRef,
            limit: 7,
            offset: 4
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil)
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == VerseID(value: "1:1:1"))
        #expect(await mockStore.endVerseID == VerseID(value: "1:1:31"))
        #expect(await mockStore.limit == 7)
        #expect(await mockStore.offset == 4)
    }

    /// Tests book retrieval functionality
    ///
    /// Steps:
    /// 1. Set up mock Bible store
    /// 2. Retrieve verses from a specific book
    /// 3. Verify that correct verses are returned
    @Test func getBook() async throws {
        let mockStore = MockBibleStoreProvider()
        let provider = BibleProvider(store: mockStore)
        let book = BookCollection.mapping[.Genesis]!

        let verses = try await provider.book(
            book: book,
            limit: 12,
            offset: 6
        )

        #expect(verses.isEmpty)
        #expect(await mockStore.searchText == nil)
        #expect(await mockStore.verseIDs == nil)
        #expect(await mockStore.startVerseID == VerseID(value: "1:1:1"))
        #expect(await mockStore.endVerseID == VerseID(value: "1:50:26"))
        #expect(await mockStore.limit == 12)
        #expect(await mockStore.offset == 6)
    }
}
