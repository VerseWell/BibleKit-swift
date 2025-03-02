@testable import BibleKit
import Testing

/// Test class for VerseID model
/// Tests verse ID constants and component parsing
/// Verifies correct handling of verse ID formats
struct VerseIDTests {
    /// Tests the start verse ID constant
    /// Verifies it represents Genesis 1:1 (1:1:1)
    @Test func verseID_start() {
        #expect(VerseID.start.value == "1:1:1")
    }

    /// Tests the end verse ID constant
    /// Verifies it represents Revelation 22:21 (66:22:21)
    @Test func verseID_end() {
        #expect(VerseID.end.value == "66:22:21")
    }

    /// Tests parsing of verse ID components
    /// Verifies:
    /// - Handling of different component lengths (1-4 components)
    /// - Correct parsing of book, chapter, verse, and subverse numbers
    /// Examples:
    /// - "66:22:21:11" -> [66, 22, 21, 11]
    /// - "66:22:21" -> [66, 22, 21]
    /// - "66:22" -> [66, 22]
    /// - "66" -> [66]
    @Test func verseID_components() {
        let testRepeatMap: [String: [Int]] = [
            "66:22:21:11": [66, 22, 21, 11],
            "66:22:21": [66, 22, 21],
            "66:22": [66, 22],
            "66": [66],
        ]

        for (key, value) in testRepeatMap {
            #expect(VerseID(value: key).components() == value)
        }
    }

    /// Tests the bookChapterVerse() method
    /// Verifies that it correctly formats the verse reference with book name and chapter:verse
    /// Example: "Genesis 1:1" for verse ID "1:1:1"
    @Test func verseID_bookChapterVerse() {
        let testCases: [String: String] = [
            "1:1:1": "Genesis 1:1",
            "66:22:21": "Revelation 22:21",
            "19:23:6": "Psalms 23:6",
        ]

        for (input, expected) in testCases {
            #expect(VerseID(value: input).bookChapterVerse() == expected)
        }
    }

    /// Tests the bookName() method
    /// Verifies that it correctly returns the BookName enum for the verse's book number
    @Test func verseID_bookName() {
        let testCases: [String: BookName] = [
            "1:1:1": .Genesis,
            "66:22:21": .Revelation,
            "19:23:6": .Psalms,
        ]

        for (input, expected) in testCases {
            #expect(VerseID(value: input).bookName() == expected)
        }
    }

    /// Tests the chapterVerseNumbers() method
    /// Verifies that it correctly extracts chapter and verse numbers as a list
    /// Example: [1, 1] for verse ID "1:1:1"
    @Test func verseID_chapterVerseNumbers() {
        let testCases: [String: [Int]] = [
            "1:1:1": [1, 1],
            "66:22:21": [22, 21],
            "19:23:6": [23, 6],
        ]

        for (input, expected) in testCases {
            #expect(VerseID(value: input).chapterVerseNumbers() == expected)
        }
    }
}
