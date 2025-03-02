@testable import BibleKit
import Testing

/// Test class for BookName enum
/// Verifies the correctness of Bible book names and their total count
struct BookNameTests {
    /// Tests that there are exactly 66 books in the Bible
    /// This matches the standard Protestant canon
    @Test func totalCount() throws {
        #expect(BookName.allCases.count == 66)
    }

    /// Tests the string representation of book names
    /// Particularly focuses on books with numerical prefixes (1/2/3)
    /// Verifies that:
    /// - Books are properly formatted (e.g., "1 Samuel" not "1Samuel")
    /// - Special cases like "Song of Solomon" are handled correctly
    @Test func bookRawValues() throws {
        #expect(BookName.Genesis.value == "Genesis")
        #expect(BookName.Samuel1.value == "1 Samuel")
        #expect(BookName.Samuel2.value == "2 Samuel")
        #expect(BookName.Kings1.value == "1 Kings")
        #expect(BookName.Kings2.value == "2 Kings")
        #expect(BookName.Chronicles1.value == "1 Chronicles")
        #expect(BookName.Chronicles2.value == "2 Chronicles")
        #expect(BookName.SongOfSolomon.value == "Song of Solomon")
        #expect(BookName.Corinthians1.value == "1 Corinthians")
        #expect(BookName.Corinthians2.value == "2 Corinthians")
        #expect(BookName.Thessalonians1.value == "1 Thessalonians")
        #expect(BookName.Thessalonians2.value == "2 Thessalonians")
        #expect(BookName.Timothy1.value == "1 Timothy")
        #expect(BookName.Timothy2.value == "2 Timothy")
        #expect(BookName.Peter1.value == "1 Peter")
        #expect(BookName.Peter2.value == "2 Peter")
        #expect(BookName.John1.value == "1 John")
        #expect(BookName.John2.value == "2 John")
        #expect(BookName.John3.value == "3 John")
    }
}
