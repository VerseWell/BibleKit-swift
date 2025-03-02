import Foundation

/// Represents a range of selected verses in the Bible.
///
/// - Parameter startBook: The book number where the selection starts
/// - Parameter endBook: The book number where the selection ends
/// - Parameter startChapter: The chapter number where the selection starts
/// - Parameter endChapter: The chapter number where the selection ends
/// - Parameter startVerse: The verse number where the selection starts
/// - Parameter endVerse: The verse number where the selection ends
public struct SelectedVerseRange {
    /// The book number where the selection starts
    private let startBook: Int
    /// The book number where the selection ends
    private let endBook: Int
    /// The chapter number where the selection starts
    private let startChapter: Int
    /// The chapter number where the selection ends
    private let endChapter: Int
    /// The verse number where the selection starts
    private let startVerse: Int
    /// The verse number where the selection ends
    private let endVerse: Int

    init(
        startBook: Int,
        endBook: Int,
        startChapter: Int,
        endChapter: Int,
        startVerse: Int,
        endVerse: Int
    ) {
        self.startBook = startBook
        self.endBook = endBook
        self.startChapter = startChapter
        self.endChapter = endChapter
        self.startVerse = startVerse
        self.endVerse = endVerse
    }
}

extension SelectedVerseRange {
    /// Creates a formatted string representation of the verse range for sharing.
    ///
    /// - Returns: A string in the format "BookName chapter:verse-verse" or "BookName chapter:verse-chapter:verse"
    public static func shareTitle(range: [SelectedVerseRange]) -> String {
        let bookName = BookCollection.allBooks[range.first!.startBook - 1].bookName.value

        return "\(bookName) \(range.first!.startChapter):"
            + range.reduce(
                ([], range.first!.startChapter, range.first!.startBook)
            ) { (acc: ([String], Int, Int), next: SelectedVerseRange) in
                let text = {
                    if $0.startBook == $0.endBook {
                        if $0.startChapter == $0.endChapter {
                            var prefix = ""
                            if $0.startChapter != acc.1 {
                                prefix = "\($0.startChapter):"
                            }
                            if $0.startVerse == $0.endVerse {
                                return "\(prefix)\($0.startVerse)"
                            } else {
                                return "\(prefix)\($0.startVerse)-\($0.endVerse)"
                            }
                        } else {
                            return "\($0.startVerse)-\($0.endChapter):\($0.endVerse)"
                        }
                    } else {
                        fatalError("Support multiple books.")
                    }
                }(next)

                return (acc.0 + [text], next.endChapter, next.endBook)
            }
            .0.joined(separator: ",")
    }
}
