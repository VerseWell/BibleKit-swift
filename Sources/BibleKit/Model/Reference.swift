import Foundation

/// Represents a range of verses in a Bible reference, from a starting verse to an ending verse.
public struct Reference: Equatable, Sendable {
    /// The starting verse reference
    public let from: VerseReference
    /// The ending verse reference
    public let to: VerseReference

    /// Initializes a new Reference with starting and ending verse references.
    /// - Parameters:
    ///   - from: The starting verse reference.
    ///   - to: The ending verse reference.
    public init(from: VerseReference, to: VerseReference) {
        self.from = from
        self.to = to
    }

    /// Ensures that the 'from' verse reference is less than or equal to the 'to' verse reference.
    ///
    /// If 'from' is greater than 'to', the references are swapped to maintain the correct order.
    ///
    /// - Returns: A new Reference object with the 'from' and 'to' references in the correct order.
    public func fixup() -> Reference {
        if from > to {
            Reference(from: to, to: from)
        } else {
            Reference(from: from, to: to)
        }
    }

    /// Generates a list of VerseID objects representing the individual verses within the reference range.
    ///
    /// - Returns: A list of VerseID objects.
    func verseIDs() -> [VerseID] {
        let startBookIdx = BookName.allCases.firstIndex(of: from.chapter.bookName)!
        let endBookIdx = BookName.allCases.firstIndex(of: to.chapter.bookName)!

        if from.chapter.bookName == to.chapter.bookName {
            if from.chapter.index == to.chapter.index {
                // Add all verses from the starting verse to the ending verse of the chapter
                return (from.index ... to.index).map { verseIdx in
                    from.chapter.verseID(verse: verseIdx)
                }
            } else {
                var verses: [VerseID] = []
                let bookName = from.chapter.bookName
                let startChapterIdx = from.chapter.index
                let endChapterIdx = to.chapter.index

                for chapterIdx in startChapterIdx ... endChapterIdx {
                    let chapterRef = ChapterReference(
                        bookName: from.chapter.bookName,
                        index: chapterIdx
                    )

                    switch chapterIdx {
                    case startChapterIdx:
                        // If it's the starting chapter, add verses from the starting verse to the end of the chapter
                        verses.append(contentsOf: Reference.createWithBook(
                            bookName: bookName,
                            fromChapter: chapterIdx,
                            toChapter: chapterIdx,
                            fromVerse: from.index,
                            toVerse: chapterRef.totalVerses()
                        ).verseIDs())

                    case endChapterIdx:
                        // If it's the ending chapter, add verses from the beginning of the chapter to the ending verse
                        verses.append(contentsOf: Reference.createWithBook(
                            bookName: bookName,
                            fromChapter: chapterIdx,
                            toChapter: chapterIdx,
                            fromVerse: 1,
                            toVerse: to.index
                        ).verseIDs())

                    default:
                        // For other chapters, add all verses from the beginning to the end of the chapter
                        verses.append(contentsOf: chapterRef.allVerseIDs())
                    }
                }
                return verses
            }
        } else {
            var verses: [VerseID] = []

            for bookIdx in startBookIdx ... endBookIdx {
                let bookName = BookName.allCases[bookIdx]

                switch bookIdx {
                case startBookIdx:
                    let book = from.chapter.book()
                    verses.append(contentsOf: Reference.createWithBook(
                        bookName: bookName,
                        fromChapter: from.chapter.index,
                        toChapter: book.totalChapters,
                        fromVerse: from.index,
                        toVerse: book.totalVerses(chapter: book.totalChapters)
                    ).verseIDs())

                case endBookIdx:
                    // If it's the ending book, add verses from the beginning of the ending chapter to the ending verse
                    verses.append(contentsOf: Reference.createWithBook(
                        bookName: bookName,
                        fromChapter: 1,
                        toChapter: to.chapter.index,
                        fromVerse: 1,
                        toVerse: to.index
                    ).verseIDs())

                default:
                    // For other books, add all verses from the book using the mapping
                    let book = BookCollection.mapping[bookName]!
                    verses.append(contentsOf: book.allVerseIDs())
                }
            }
            return verses
        }
    }

    /// Creates a Reference object for a specific range of verses within a book and chapter.
    ///
    /// - Parameters:
    ///   - bookName: The name of the book.
    ///   - fromChapter: The starting chapter number.
    ///   - toChapter: The ending chapter number.
    ///   - fromVerse: The starting verse number.
    ///   - toVerse: The ending verse number.
    /// - Returns: A Reference object representing the specified verse range.
    public static func createWithBook(
        bookName: BookName,
        fromChapter: Int,
        toChapter: Int,
        fromVerse: Int,
        toVerse: Int
    ) -> Reference {
        Reference(
            from: VerseReference(
                chapter: ChapterReference(
                    bookName: bookName,
                    index: fromChapter
                ),
                index: fromVerse
            ),
            to: VerseReference(
                chapter: ChapterReference(
                    bookName: bookName,
                    index: toChapter
                ),
                index: toVerse
            )
        )
    }
}
