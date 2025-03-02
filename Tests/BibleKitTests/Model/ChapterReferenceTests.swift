@testable import BibleKit
import Testing

/// Test class for ChapterReference model
/// Tests chapter reference functionality and book information retrieval
struct ChapterReferenceTests {
    /// Tests chapter reference for Genesis 1
    /// Verifies:
    /// - Book name is correctly set to Genesis
    /// - Total chapters in Genesis (50)
    /// - Total verses in Genesis 1 (31)
    @Test func genesisChapter1Properties() throws {
        let ref = ChapterReference(bookName: .Genesis, index: 1)
        let book = ref.book()
        #expect(book.bookName == .Genesis)
        #expect(book.totalChapters == 50)
        #expect(ref.totalVerses() == 31)
    }

    /// Tests start and end verse IDs for Genesis chapter 1
    /// Verifies:
    /// - Start verse ID is Genesis 1:1
    /// - End verse ID is Genesis 1:31
    @Test func chapterReferenceVerseIDs() throws {
        let ref = ChapterReference(bookName: .Genesis, index: 1)

        // Verify start verse ID (Genesis 1:1)
        #expect(ref.startVerseID == ref.verseID(verse: 1))

        // Verify end verse ID (Genesis 1:31)
        #expect(ref.endVerseID == ref.verseID(verse: 31))
    }
}
