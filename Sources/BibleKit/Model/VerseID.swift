import Foundation

/// Represents the unique identifier for a verse in the Bible.
/// The ID follows the format "book:chapter:verse" where:
/// - book is a number from 1-66 representing the book's position in the Bible
/// - chapter is the chapter number within that book
/// - verse is the verse number within that chapter
///
/// For example, "1:1:1" represents Genesis 1:1 (first book, first chapter, first verse)
public struct VerseID: Identifiable, Hashable, Sendable {
    /// The string representation of the verse ID in the format "book:chapter:verse"
    public let value: String

    /// The identifier for Identifiable conformance
    public var id: String { value }

    /// Initializes a new VerseID with the provided string value.
    ///
    /// - Parameter value: A string in the format "book:chapter:verse" where each component is a number.
    /// For example, "1:1:1" represents Genesis 1:1.
    public init(value: String) {
        self.value = value
    }

    /// The VerseID of the first verse in the Bible (Genesis 1:1).
    public static let start = VerseID(value: "1:1:1")

    /// The VerseID of the last verse in the Bible (Revelation 22:21).
    public static let end = VerseID(value: "66:22:21")

    /// Returns a human-readable description of the verse ID, including the book name and chapter:verse.
    /// For example, "Genesis 1:1" for verse ID "1:1:1".
    ///
    /// - Returns: The formatted string in the format "BookName chapter:verse"
    public func bookChapterVerse() -> String {
        "\(bookName().value) \(chapterVerse())"
    }

    /// Gets the BookName enum value for this verse's book.
    /// The book number (first component) is used to index into the BookName entries.
    ///
    /// - Returns: The BookName representing this verse's book
    public func bookName() -> BookName {
        BookName.allCases[components().first! - 1]
    }

    /// Returns the chapter and verse numbers as a colon-separated string.
    /// For example, "1:1" for verse ID "1:1:1".
    ///
    /// - Returns: The chapter:verse portion of the verse reference
    public func chapterVerse() -> String {
        chapterVerseNumbers().map(String.init).joined(separator: ":")
    }

    /// Returns a list containing just the chapter and verse numbers.
    /// For example, [1, 1] for verse ID "1:1:1".
    ///
    /// - Returns: List containing [chapter, verse] numbers
    func chapterVerseNumbers() -> [Int] {
        Array(components().dropFirst())
    }

    /// Splits the verse ID string into its components (book, chapter, verse) and returns them as integers.
    /// For example, "1:1:1" becomes [1, 1, 1].
    ///
    /// - Returns: A list of integers [book, chapter, verse]
    /// - Throws: IllegalArgumentException if any component cannot be parsed as an integer
    func components() -> [Int] {
        value.split(separator: ":").compactMap { Int($0) }
    }
}
