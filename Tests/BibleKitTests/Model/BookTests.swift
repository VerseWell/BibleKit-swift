@testable import BibleKit
import Testing

/// Test class for Book model
/// Verifies the structure and content of Bible books
/// Tests book properties, chapter counts, and verse numbering
struct BookTests {
    /// Tests the basic properties of Genesis book
    /// Verifies:
    /// - Book name is correctly set
    /// - Total number of chapters
    /// - Total verse count
    /// - Sum of verses across chapters
    /// - Verse count in first chapter
    /// - Verse IDs generation for first chapter
    /// - Verse ID format
    @Test func genesisBookProperties() {
        let book = BookCollection.mapping[.Genesis]!
        #expect(book.bookName == .Genesis)
        #expect(book.totalChapters == 50)
        #expect(book.allVerseIDs().count == 1533)
        #expect(book.verses.reduce(0, +) == 1533)
        #expect(book.totalVerses(chapter: 1) == 31)
        #expect(book.allVerseIDs(chapter: 1).count == 31)
        #expect(book.verseID(chapter: 1, verse: 1).value == "1:1:1")
    }

    /// Tests the start and end verse IDs of Genesis book
    /// Verifies:
    /// - Start verse ID is Genesis 1:1 (1:1:1)
    /// - End verse ID is Genesis 50:26 (1:50:26)
    @Test func genesisBookVerseIDs() {
        let book = BookCollection.mapping[.Genesis]!

        // Verify start verse ID (Genesis 1:1)
        #expect(book.startVerseID.value == "1:1:1")

        // Verify end verse ID (Genesis 50:26)
        #expect(book.endVerseID.value == "1:50:26")
    }
}
