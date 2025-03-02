@testable import BibleKit
import Testing

/// Test class for Verse model and its sharing functionality
/// Tests various scenarios of verse reference formatting and text sharing
/// Covers single verses, multiple verses, chapter breaks, and verse ranges
struct VerseTests {
    /// Tests that creating share text with empty verse list throws exception
    @Test func verseShareText_emptyList() {
        // FIXME: - this should crash because there is no verse
//        _ = Verse.createShareText(verses: [])
    }

    /// Tests share title formatting for a single verse
    /// Example: "Genesis 1:1"
    @Test func shareTitle_singleVerse() {
        let verses = ["1:1:1"].map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:1")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "...")
    }

    /// Tests share title formatting for multiple verses at chapter end
    /// Example: "Genesis 50:23-26"
    @Test func shareTitle_mutipleVerses_end() {
        let verses = ["1:50:23", "1:50:24", "1:50:25", "1:50:26"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 50:23-26")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[23] ... [24] ... [25] ... [26] ...")
    }

    /// Tests share title formatting for two consecutive verses
    /// Example: "Genesis 1:1-2"
    @Test func shareTitle_twoVerses() {
        let verses = ["1:1:1", "1:1:2"].map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:1-2")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[1] ... [2] ...")
    }

    /// Tests share title formatting for multiple consecutive verses
    /// Example: "Genesis 1:1-3"
    @Test func shareTitle_multipleVerses() {
        let verses = ["1:1:1", "1:1:2", "1:1:3"].map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:1-3")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[1] ... [2] ... [3] ...")
    }

    /// Tests share title formatting for non-consecutive verses with single verse gap
    /// Example: "Genesis 1:2-3,5"
    @Test func shareTitle_multipleVerses_withBreak_singleVerse() {
        let verses = ["1:1:2", "1:1:3", "1:1:5"].map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:2-3,5")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[2] ... [3] ... [5] ...")
    }

    /// Tests share title formatting for non-consecutive verses with multiple verse ranges
    /// Example: "Genesis 1:2-3,5-7"
    @Test func shareTitle_multipleVerses_withBreak_twoVerses() {
        let verses = ["1:1:2", "1:1:3", "1:1:5", "1:1:6", "1:1:7"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:2-3,5-7")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[2] ... [3] ... [5] ... [6] ... [7] ...")
    }

    /// Tests share title formatting for multiple non-consecutive verse ranges
    /// Example: "Genesis 1:2,4-6,9,14-15"
    @Test func shareTitle_multipleVerses_withMutipleBreak_mutipleVerses() {
        let verses = ["1:1:2", "1:1:4", "1:1:5", "1:1:6", "1:1:9", "1:1:14", "1:1:15"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:2,4-6,9,14-15")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[2] ... [4] ... [5] ... [6] ... [9] ... [14] ... [15] ...")
    }

    /// Tests share title formatting for verses spanning multiple chapters
    /// Example: "Genesis 1:31-2:1"
    @Test func shareTitle_multipleChapters_singleVerse() {
        let verses = ["1:1:31", "1:2:1"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:31-2:1")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[31] ... [2:1] ...")
    }

    /// Tests share title formatting for non-consecutive verses across chapters
    /// Example: "Genesis 1:31,2:2"
    @Test func shareTitle_multipleChapters_singleVerseEnd_withBreak() {
        let verses = ["1:1:31", "1:2:2"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:31,2:2")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[31] ... [2:2] ...")
    }

    /// Tests share title formatting for consecutive verses across chapters
    /// Example: "Genesis 1:30-2:4"
    @Test func shareTitle_multipleChapters_multipleVerses() {
        let verses = ["1:1:30", "1:1:31", "1:2:1", "1:2:2", "1:2:3", "1:2:4"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:30-2:4")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[30] ... [31] ... [2:1] ... [2] ... [3] ... [4] ...")
    }

    /// Tests share title formatting for non-consecutive verses across chapters
    /// Example: "Genesis 1:30-2:1,3-4"
    @Test func shareTitle_multipleChapters_multipleVerses_withBreak() {
        let verses = ["1:1:30", "1:1:31", "1:2:1", "1:2:3", "1:2:4"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:30-2:1,3-4")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[30] ... [31] ... [2:1] ... [3] ... [4] ...")
    }

    /// Tests share title formatting for complex verse ranges across multiple chapters
    /// Example: "Genesis 1:30-2:1,3-5,25-3:2,24,4:2"
    @Test func shareTitle_multipleChapters_multipleVerses_withMutipleBreak_mutipleVerses() {
        let verses = ["1:1:30", "1:1:31", "1:2:1", "1:2:3", "1:2:4", "1:2:5", "1:2:25", "1:3:1", "1:3:2", "1:3:24", "1:4:2"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:30-2:1,3-5,25-3:2,24,4:2")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[30] ... [31] ... [2:1] ... [3] ... [4] ... [5] ... [25] ... [3:1] ... [2] ... [24] ... [4:2] ...")
    }

    /// Tests share title formatting for non-consecutive verses across chapters
    /// Example: "Genesis 1:30,2:2"
    @Test func shareTitle_multipleChapters_singleVerse_withBreak() {
        let verses = ["1:1:30", "1:2:2"]
            .map { Verse(id: .init(value: $0), text: "...") }
        let selectedVerses = Verse.selectedVerseRange(verses: verses)
        #expect(SelectedVerseRange.shareTitle(range: selectedVerses) == "Genesis 1:30,2:2")
        #expect(Verse.shareVersesText(verses: verses).joined(separator: " ") == "[30] ... [2:2] ...")
    }
}
