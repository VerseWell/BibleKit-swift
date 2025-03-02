import Foundation

/// Represents a reference to a specific verse within a chapter of a book.
public struct VerseReference: Equatable, Comparable, Sendable {
    /// The chapter reference
    public let chapter: ChapterReference
    /// The verse number within the chapter
    let index: Int

    /// Creates a VerseID object from this verse reference.
    ///
    /// - Returns: The corresponding VerseID.
    public func verseID() -> VerseID {
        chapter.verseID(verse: index)
    }

    /// Compares this VerseReference to another VerseReference for order.
    ///
    /// The comparison is performed in the following order:
    /// 1. Book name
    /// 2. Chapter index
    /// 3. Verse index
    ///
    /// - Parameter lhs: The left-hand side VerseReference to compare.
    /// - Parameter rhs: The right-hand side VerseReference to compare to.
    /// - Returns: True if this VerseReference is less than rhs.
    public static func < (lhs: VerseReference, rhs: VerseReference) -> Bool {
        // 1. Compare book names
        let lhsBookIndex = BookName.allCases.firstIndex(of: lhs.chapter.bookName)!
        let rhsBookIndex = BookName.allCases.firstIndex(of: rhs.chapter.bookName)!

        if lhsBookIndex != rhsBookIndex {
            return lhsBookIndex < rhsBookIndex
        }

        // 2. If book names are the same, compare chapter indices
        if lhs.chapter.index != rhs.chapter.index {
            return lhs.chapter.index < rhs.chapter.index
        }

        // 3. If both book names and chapter indices are the same, compare verse indices
        return lhs.index < rhs.index
    }

    /// Creates a VerseReference from a VerseID string.
    ///
    /// - Parameter value: The VerseID string.
    /// - Returns: A VerseReference if the input is valid, otherwise nil.
    public static func fromVerseID(_ value: String) -> VerseReference? {
        let verseID = VerseID(value: value)
        // Get the components (book, chapter, verse) from the VerseID
        let components = verseID.components()
        // Check if the VerseID has the correct number of components
        if components.count != 3 {
            return nil
        }

        // Extract book index and validate it
        let bookIdx = components[0]
        if !(1 ... BookName.allCases.count).contains(bookIdx) {
            return nil
        }

        // Get book name and book object from the mapping
        let bookName = BookName.allCases[bookIdx - 1]
        let book = BookCollection.mapping[bookName]!

        // Extract chapter index and validate it
        let chapterIdx = components[1]
        if !(1 ... book.totalChapters).contains(chapterIdx) {
            return nil
        }

        // Extract verse index and validate it
        let verseIdx = components[2]
        if !(1 ... book.totalVerses(chapter: chapterIdx)).contains(verseIdx) {
            return nil
        }

        return VerseReference(
            chapter: ChapterReference(
                bookName: bookName,
                index: chapterIdx
            ),
            index: verseIdx
        )
    }
}
