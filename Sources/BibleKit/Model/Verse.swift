import BibleKitDB
import Foundation

/// Represents a single verse in the Bible with its unique identifier and text content.
/// This class provides functionality for verse manipulation, range selection, and text formatting.
public struct Verse: Equatable, Hashable, Sendable {
    /// The unique identifier for this verse in the format "book:chapter:verse"
    public let id: VerseID
    /// The actual text content of the verse
    public let text: String
    /// A numeric key used for sorting verses in their biblical order
    let sortKey: Int

    init(id: VerseID, text: String) {
        self.id = id
        self.text = text
        self.sortKey = VerseEntity.sortKey(id: id.value)
    }
}

extension Verse {
    /// Analyzes a list of verses and groups them into continuous ranges.
    /// This is useful for displaying or sharing multiple verses in a compact format.
    ///
    /// For example, verses 1-3 and 5-7 would be grouped into two separate ranges.
    ///
    /// - Parameter verses: The list of verses to analyze
    /// - Returns: A list of SelectedVerseRange objects representing continuous verse ranges
    /// - Throws: IllegalArgumentException if verses list is empty or contains verses from multiple books
    public static func selectedVerseRange(verses: [Verse]) -> [SelectedVerseRange] {
        guard !verses.isEmpty else {
            fatalError("Verses should not be empty.")
        }

        let sortedVerses = verses.sorted { $0.sortKey < $1.sortKey }
        let allBooks = Set(sortedVerses.map { $0.id.components().first! }).sorted()

        guard allBooks.count == 1 else {
            fatalError("Multiple books not supported.")
        }

        let bookName = sortedVerses.first!.id.bookName()

        let selectedVerses: [SelectedVerseRange] = {
            if sortedVerses.count == 1 {
                // Handle single verse case
                let components = sortedVerses.first!.id.components()
                return [
                    SelectedVerseRange(
                        startBook: components.first!,
                        endBook: components.first!,
                        startChapter: components.dropFirst().first!,
                        endChapter: components.dropFirst().first!,
                        startVerse: components.last!,
                        endVerse: components.last!
                    ),
                ]
            } else {
                // Handle multiple verses case
                var selectedVerses = [SelectedVerseRange]()

                // Get all verse IDs from the book and find our starting point
                let allVerseIDs = BookCollection.mapping[bookName]!
                    .allVerseIDs()
                    .drop {
                        Verse(id: $0, text: "").sortKey <
                            Verse(id: sortedVerses.first!.id, text: "").sortKey
                    }

                var selectedVerseIDs: [Verse] = sortedVerses.reversed()

                var calculatingRange = false
                var startChapter: Int = selectedVerseIDs.last!.id.components().dropFirst().first!
                var endChapter: Int = selectedVerseIDs.last!.id.components().dropFirst().first!
                var startIdx: Int = selectedVerseIDs.last!.id.components().last!
                var endIdx: Int = selectedVerseIDs.last!.id.components().last!

                // Helper function to add a completed range
                func addBreak() {
                    selectedVerses.append(
                        SelectedVerseRange(
                            startBook: sortedVerses.first!.id.components().first!,
                            endBook: sortedVerses.first!.id.components().first!,
                            startChapter: startChapter,
                            endChapter: endChapter,
                            startVerse: startIdx,
                            endVerse: endIdx
                        )
                    )
                }

                // Iterate through all verses to find continuous ranges
                for verseId in allVerseIDs {
                    if verseId.value == selectedVerseIDs.last?.id.value {
                        if !calculatingRange {
                            startChapter = verseId.components().dropFirst().first!
                            startIdx = verseId.components().last!
                        }
                        calculatingRange = true
                        endChapter = verseId.components().dropFirst().first!
                        endIdx = verseId.components().last!
                        selectedVerseIDs = Array(selectedVerseIDs.dropLast(1))
                    } else if selectedVerseIDs.isEmpty {
                        break
                    } else {
                        if calculatingRange { addBreak() }
                        calculatingRange = false
                    }
                }

                addBreak()
                return selectedVerses
            }
        }()

        return selectedVerses
    }

    /// Formats a list of verses for sharing, adding appropriate chapter and verse numbers.
    /// The verses are formatted according to standard Bible citation rules:
    /// - First verse in a chapter includes the chapter number
    /// - Subsequent verses in the same chapter only show verse number
    /// - Chapter numbers are repeated when crossing chapter boundaries
    ///
    /// - Parameter verses: The list of verses to format
    /// - Returns: List of formatted verse strings
    /// - Throws: IllegalArgumentException if verses list is empty or contains verses from multiple books
    public static func shareVersesText(verses: [Verse]) -> [String] {
        guard !verses.isEmpty else {
            fatalError("Verses should not be empty.")
        }

        let sortedVerses = verses.sorted { $0.sortKey < $1.sortKey }
        let allBooks = Set(sortedVerses.map { $0.id.components().first! }).sorted()

        guard allBooks.count == 1 else {
            fatalError("Multiple books not supported.")
        }

        let bookName = sortedVerses.first!.id.bookName()
        let startBook = BookCollection.mapping[bookName]!

        var addChapterPrefix = false
        var versesText = [String]()

        var startChapter: Int = sortedVerses.first!.id.components().dropFirst().first!

        if sortedVerses.count == 1 {
            versesText.append(sortedVerses.first!.text)
        } else {
            for verse in sortedVerses {
                let currentChapter = verse.id.components().dropFirst().first!

                var prefix = ""

                // Add chapter number if needed
                if addChapterPrefix || startChapter != currentChapter {
                    prefix = "\(verse.id.components().dropFirst().first!):"
                }

                versesText.append("[\(prefix)\(verse.id.components().last!)] \(verse.text)")

                // Check if we need to add chapter prefix in next iteration
                if startBook.totalVerses(chapter: currentChapter) == verse.id.components().last! {
                    if startBook.totalChapters == currentChapter {
                        // Right now the method doesn't support sharing across multiple books
                        // There's nothing to select more in this book.
                    } else {
                        // We should prefix with chapter on next loop.
                        addChapterPrefix = true
                    }
                } else {
                    addChapterPrefix = false
                }

                startChapter = currentChapter
            }
        }

        return versesText
    }

    /// Creates a complete share text including the verse reference and formatted verse text.
    /// For example: "Genesis 1:1-3 - [1] In the beginning... [2] And the earth... [3] And God said..."
    ///
    /// - Parameter verses: The list of verses to share
    /// - Returns: A formatted string containing the verse reference and text
    /// - Throws: IllegalArgumentException if verses list is empty or contains verses from multiple books
    public static func createShareText(verses: [Verse]) -> String {
        let title = SelectedVerseRange.shareTitle(range: selectedVerseRange(verses: verses))
        let verseText = shareVersesText(verses: verses).joined(separator: " ")
        return "\(title) - \(verseText)"
    }
}
