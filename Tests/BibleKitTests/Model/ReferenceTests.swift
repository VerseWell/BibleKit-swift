@testable import BibleKit
import Testing

/// Test class for Reference model
/// Tests verse reference ranges and verse ID generation
/// Covers various scenarios from single chapter to entire Bible
struct ReferenceTests {
    /// Tests verse ID generation for verses within a single chapter
    /// Example: Genesis 1:1-3
    /// Verifies correct sequence of verse IDs is generated
    @Test func verseIDs_singleBook_singleChapter() {
        let ref = Reference(
            from: VerseReference.fromVerseID("1:1:1")!,
            to: VerseReference.fromVerseID("1:1:3")!
        )

        #expect(ref.verseIDs() == [
            VerseID(value: "1:1:1"),
            VerseID(value: "1:1:2"),
            VerseID(value: "1:1:3"),
        ])
    }

    /// Tests verse ID generation across multiple chapters in a single book
    /// Example: Genesis 1:30-3:3
    /// Verifies:
    /// - Correct handling of chapter transitions
    /// - Complete verse sequences within chapters
    @Test func verseIDs_singleBook_multipleChapters() {
        let ref = Reference(
            from: VerseReference.fromVerseID("1:1:30")!,
            to: VerseReference.fromVerseID("1:3:3")!
        )

        var expected: [VerseID] = []
        expected.append(VerseID(value: "1:1:30"))
        expected.append(VerseID(value: "1:1:31"))

        expected.append(contentsOf: BookCollection.mapping[.Genesis]!.allVerseIDs(chapter: 2))

        expected.append(VerseID(value: "1:3:1"))
        expected.append(VerseID(value: "1:3:2"))
        expected.append(VerseID(value: "1:3:3"))

        #expect(ref.verseIDs() == expected)
    }

    /// Tests verse ID generation across multiple books
    /// Example: Genesis 50:25 - Leviticus 1:3
    /// Verifies:
    /// - Correct handling of book transitions
    /// - Complete verse sequences within books
    @Test func verseIDs_multipleBooks() {
        let ref = Reference(
            from: VerseReference.fromVerseID("1:50:25")!,
            to: VerseReference.fromVerseID("3:1:3")!
        )

        var expected: [VerseID] = []
        expected.append(VerseID(value: "1:50:25"))
        expected.append(VerseID(value: "1:50:26"))

        expected.append(contentsOf: BookCollection.mapping[.Exodus]!.allVerseIDs())

        expected.append(VerseID(value: "3:1:1"))
        expected.append(VerseID(value: "3:1:2"))
        expected.append(VerseID(value: "3:1:3"))

        #expect(ref.verseIDs() == expected)
    }

    /// Tests verse ID generation from start of Bible to a specific verse
    /// Example: Genesis 1:1 - Leviticus 1:3
    /// Verifies complete verse sequence from Genesis through specified books
    @Test func verseIDs_multipleBooks_startingGenesis() {
        let ref = Reference(
            from: VerseReference.fromVerseID(VerseID.start.value)!,
            to: VerseReference.fromVerseID("3:1:3")!
        )

        var expected: [VerseID] = []
        expected.append(contentsOf: BookCollection.mapping[.Genesis]!.allVerseIDs())
        expected.append(contentsOf: BookCollection.mapping[.Exodus]!.allVerseIDs())
        expected.append(VerseID(value: "3:1:1"))
        expected.append(VerseID(value: "3:1:2"))
        expected.append(VerseID(value: "3:1:3"))

        #expect(ref.verseIDs() == expected)
    }

    /// Tests verse ID generation from a specific verse to end of Bible
    /// Example: 3 John 1:13 - Revelation 22:21
    /// Verifies complete verse sequence through end of Revelation
    @Test func verseIDs_multipleBooks_endingRevelation() {
        let ref = Reference(
            from: VerseReference.fromVerseID("64:1:13")!,
            to: VerseReference.fromVerseID(VerseID.end.value)!
        )

        var expected: [VerseID] = []
        expected.append(VerseID(value: "64:1:13"))
        expected.append(VerseID(value: "64:1:14"))

        expected.append(contentsOf: BookCollection.mapping[.Jude]!.allVerseIDs())
        expected.append(contentsOf: BookCollection.mapping[.Revelation]!.allVerseIDs())

        #expect(ref.verseIDs() == expected)
    }

    /// Tests verse ID generation for entire Bible
    /// Genesis 1:1 through Revelation 22:21
    /// Verifies complete sequence of all verse IDs in canonical order
    @Test func verseIDs_allBooks() {
        let ref = Reference(
            from: VerseReference.fromVerseID(VerseID.start.value)!,
            to: VerseReference.fromVerseID(VerseID.end.value)!
        )

        var expected: [VerseID] = []
        for book in BookCollection.allBooks {
            expected.append(contentsOf: book.allVerseIDs())
        }

        #expect(ref.verseIDs() == expected)
    }

    /// Tests the fixup method of Reference class
    /// Verifies that:
    /// 1. When 'from' verse is greater than 'to' verse, they are swapped
    /// 2. When verses are already in correct order, no change occurs
    @Test func fixup() {
        // Test case where swapping is needed (from > to)
        let refNeedsSwap = Reference(
            from: VerseReference.fromVerseID("3:1:3")!,
            to: VerseReference.fromVerseID("1:1:1")!
        )
        let swappedRef = refNeedsSwap.fixup()
        #expect(swappedRef.from.verseID().value == "1:1:1")
        #expect(swappedRef.to.verseID().value == "3:1:3")

        // Test case where no swapping is needed (from < to)
        let refNoSwap = Reference(
            from: VerseReference.fromVerseID("1:1:1")!,
            to: VerseReference.fromVerseID("3:1:3")!
        )
        let unchangedRef = refNoSwap.fixup()
        #expect(unchangedRef.from.verseID().value == "1:1:1")
        #expect(unchangedRef.to.verseID().value == "3:1:3")
    }
}
