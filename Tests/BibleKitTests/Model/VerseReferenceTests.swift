@testable import BibleKit
import Testing

/// Test class for VerseReference
/// Verifies the parsing and validation of Bible verse references
/// Tests both valid and invalid verse ID formats
struct VerseReferenceTests {
    /// Tests the creation of VerseReference from a valid verse ID
    /// Verifies:
    /// - Correct parsing of book, chapter, and verse numbers
    /// - Proper conversion back to verse ID format
    /// Example: "1:1:1" should parse to Genesis 1:1
    @Test func verseReference_fromVerseID() {
        let ref = VerseReference.fromVerseID("1:1:1")
        #expect(ref != nil)
        #expect(ref?.chapter.bookName == .Genesis)
        #expect(ref?.chapter.index == 1)
        #expect(ref?.index == 1)
        #expect(ref?.verseID().value == "1:1:1")
    }

    /// Tests validation of verse IDs with invalid formats
    /// Verifies handling of:
    /// - Zero values in book/chapter/verse (invalid)
    /// - Out of range values
    /// - Edge cases like last verse of Revelation
    /// Format tested: "book:chapter:verse" where each component must be valid
    @Test func verseReference_fromVerseID_invalidCase() {
        #expect(VerseReference.fromVerseID("1:1:1") != nil)
        #expect(VerseReference.fromVerseID("1:1:0") == nil)
        #expect(VerseReference.fromVerseID("1:0:1") == nil)
        #expect(VerseReference.fromVerseID("0:1:1") == nil)
        #expect(VerseReference.fromVerseID("66:22:21") != nil)
        #expect(VerseReference.fromVerseID("66:22:22") == nil)
        #expect(VerseReference.fromVerseID("66:23:21") == nil)
        #expect(VerseReference.fromVerseID("67:22:21") == nil)
    }

    /// Tests the comparison functionality between verse references
    /// Verifies:
    /// - Comparison between different books
    /// - Comparison between different chapters in same book
    /// - Comparison between different verses in same chapter
    /// - Equality comparison
    @Test func verseReference_compareTo() {
        // Create test references
        let genesis1_1 = VerseReference.fromVerseID("1:1:1")! // Genesis 1:1
        let genesis1_2 = VerseReference.fromVerseID("1:1:2")! // Genesis 1:2
        let genesis2_1 = VerseReference.fromVerseID("1:2:1")! // Genesis 2:1
        let exodus1_1 = VerseReference.fromVerseID("2:1:1")! // Exodus 1:1
        let genesis1_1_copy = VerseReference.fromVerseID("1:1:1")! // Genesis 1:1

        // Additional test references for multi-digit book numbers
        let secondSamuel1_1 = VerseReference.fromVerseID("10:1:1")! // 2 Samuel 1:1
        let firstKings1_1 = VerseReference.fromVerseID("11:1:1")! // 1 Kings 1:1
        let revelation1_1 = VerseReference.fromVerseID("66:1:1")! // Revelation 1:1

        // Test different books
        #expect(genesis1_1 < exodus1_1)
        #expect(exodus1_1 > genesis1_1)

        // Test different chapters in same book
        #expect(genesis1_1 < genesis2_1)
        #expect(genesis2_1 > genesis1_1)

        // Test different verses in same chapter
        #expect(genesis1_1 < genesis1_2)
        #expect(genesis1_2 > genesis1_1)

        // Test equal verses
        #expect(genesis1_1 == genesis1_1_copy)

        // Test books with different digit lengths
        #expect(genesis1_1 < secondSamuel1_1) // Genesis should come before 2 Samuel
        #expect(secondSamuel1_1 > genesis1_1) // 2 Samuel should come after Genesis

        // Test consecutive multi-digit books
        #expect(secondSamuel1_1 < firstKings1_1) // 2 Samuel should come before 1 Kings
        #expect(firstKings1_1 > secondSamuel1_1) // 1 Kings should come after 2 Samuel

        // Test first book vs last book
        #expect(genesis1_1 < revelation1_1) // Genesis should come before Revelation
        #expect(revelation1_1 > genesis1_1) // Revelation should come after Genesis
    }
}
