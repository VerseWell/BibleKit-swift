import Foundation

/// Represents a reference to a specific chapter within a book.
public struct ChapterReference: Equatable, Sendable {
    /// The name of the book
    public let bookName: BookName
    /// The chapter number within the book
    let index: Int

    /// Creates a new ChapterReference.
    ///
    /// - Parameters:
    ///   - bookName: The name of the book
    ///   - index: The chapter number within the book
    public init(bookName: BookName, index: Int) {
        self.bookName = bookName
        self.index = index
    }

    /// The first verse ID of the chapter.
    var startVerseID: VerseID {
        verseID(verse: 1)
    }

    /// The last verse ID of the chapter.
    var endVerseID: VerseID {
        verseID(verse: totalVerses())
    }

    /// Retrieves the Book object associated with this chapter reference.
    ///
    /// - Returns: The corresponding Book object.
    public func book() -> Book {
        BookCollection.mapping[bookName]!
    }

    /// Gets the total number of verses in this chapter.
    ///
    /// - Returns: The total number of verses.
    func totalVerses() -> Int {
        book().totalVerses(chapter: index)
    }

    /// Generates a list of VerseID objects for all verses in this chapter.
    ///
    /// - Returns: A list of VerseID objects.
    func allVerseIDs() -> [VerseID] {
        book().allVerseIDs(chapter: index)
    }

    /// Creates a VerseID from the verse number.
    ///
    /// - Parameter verse: The verse number within the chapter.
    /// - Returns: The corresponding VerseID.
    func verseID(verse: Int) -> VerseID {
        book().verseID(chapter: index, verse: verse)
    }
}
