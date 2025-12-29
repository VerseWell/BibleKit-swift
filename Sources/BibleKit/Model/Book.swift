import Foundation

/// Represents a book in the Bible, containing information about its chapters and verses.
public struct Book: Sendable {
    /// The name of the book
    public let bookName: BookName
    /// The total number of chapters in the book
    public let totalChapters: Int
    /// A list of verse counts for each chapter
    let verses: [Int]

    /// Creates a new Book instance.
    ///
    /// - Parameters:
    ///   - bookName: The name of the book.
    ///   - totalChapters: The total number of chapters in the book.
    ///   - verses: A list of verse counts for each chapter.
    init(
        bookName: BookName,
        totalChapters: Int,
        verses: [Int]
    ) {
        self.bookName = bookName
        self.totalChapters = totalChapters
        self.verses = verses
    }

    /// The first verse ID of the book (1:1:1 format).
    var startVerseID: VerseID {
        verseID(chapter: 1, verse: 1)
    }

    /// The last verse ID of the book (book:lastChapter:lastVerse format).
    var endVerseID: VerseID {
        verseID(chapter: totalChapters, verse: totalVerses(chapter: totalChapters))
    }

    /// Returns the total number of verses in a given chapter.
    ///
    /// - Parameter chapter: The chapter number.
    /// - Returns: The total number of verses in the chapter.
    public func totalVerses(chapter: Int) -> Int {
        verses[chapter - 1]
    }

    /// Generates a list of VerseID objects for all verses in this book.
    ///
    /// - Returns: A list of VerseID objects.
    public func allVerseIDs() -> [VerseID] {
        (1 ... totalChapters).flatMap { allVerseIDs(chapter: $0) }
    }

    /// Generates a list of VerseID objects for all verses in a specific chapter in this book.
    ///
    /// - Parameter chapter: The chapter number.
    /// - Returns: A list of VerseID objects.
    public func allVerseIDs(chapter: Int) -> [VerseID] {
        let bookIndex = bookIdx()
        return (1 ... totalVerses(chapter: chapter)).map {
            verseID(book: bookIndex, chapter: chapter, verse: $0)
        }
    }

    /// Creates a VerseID from the book number, chapter number, and verse number.
    ///
    /// - Parameters:
    ///   - chapter: The chapter number within the book.
    ///   - verse: The verse number within the chapter.
    /// - Returns: The corresponding VerseID.
    func verseID(chapter: Int, verse: Int) -> VerseID {
        verseID(book: bookIdx(), chapter: chapter, verse: verse)
    }

    /// Returns the index of the book within the BookName entries.
    ///
    /// - Returns: The book index.
    private func bookIdx() -> Int {
        BookName.allCases.firstIndex(of: bookName)! + 1
    }

    /// Creates a VerseID from the book number, chapter number, and verse number.
    ///
    /// - Parameters:
    ///   - book: The book number.
    ///   - chapter: The chapter number within the book.
    ///   - verse: The verse number within the chapter.
    /// - Returns: The corresponding VerseID.
    private func verseID(book: Int, chapter: Int, verse: Int) -> VerseID {
        VerseID(value: "\(book):\(chapter):\(verse)")
    }
}
