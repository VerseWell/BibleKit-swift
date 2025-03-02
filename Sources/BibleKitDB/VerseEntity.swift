import Foundation

/// Represents a verse entity in the database.
public struct VerseEntity: Equatable, Sendable {
    /// The unique identifier for the verse.
    public let id: String

    /// The text content of the verse.
    public let text: String

    /// The sort key for the verse.
    let key: Int

    public init(id: String, text: String) {
        self.id = id
        self.text = text
        self.key = Self.sortKey(id: id)
    }
}

extension VerseEntity {
    public static func sortKey(id: String) -> Int {
        // Helper function to pad the numbers
        func pad(_ number: String) -> String {
            switch number.count {
            case 1: "00\(number)"
            case 2: "0\(number)"
            default: number
            }
        }

        let components = id.split(separator: ":")
        guard components.count == 3 else {
            fatalError("Invalid number string formed from id")
        }

        let chapter = String(components[1])
        let verse = String(components[2])

        let paddedChapter = pad(chapter)
        let paddedVerse = pad(verse)

        // Combine the parts into the final number string
        let numberString = String(components[0]) + paddedChapter + paddedVerse

        // Convert to an integer safely
        guard let key = Int(numberString) else {
            fatalError("Invalid number string formed from id")
        }

        return key
    }
}
