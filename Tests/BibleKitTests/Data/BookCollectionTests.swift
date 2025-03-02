@testable import BibleKit
import Testing

/// Test class for BookCollection
/// Verifies the integrity and accuracy of Bible book data including:
/// - Book counts in Old and New Testaments
/// - Chapter and verse counts for each book
/// - Verse references and IDs
struct BookCollectionTests {
    /// Tests the total count of books in Old Testament, New Testament, and complete Bible
    /// Verifies:
    /// - Old Testament has 39 books
    /// - New Testament has 27 books
    /// - Complete Bible has 66 books
    @Test func totalCount() throws {
        #expect(BookCollection.oldTestamentBooks.count == 39)
        #expect(BookCollection.newTestamentBooks.count == 27)
        #expect(BookCollection.allBooks.count == 66)
    }

    /// Tests that each book has the correct number of chapters with verse counts
    /// Verifies that the verses array size matches the total number of chapters for each book
    @Test func versesTotalExistsForEachChapter() throws {
        for book in BookCollection.allBooks {
            #expect(book.verses.count == book.totalChapters)
        }
    }

    /// Tests the total verse count from Genesis to Revelation
    /// Verifies that the complete Bible contains exactly 31,102 verses
    @Test func referenceTotalBookCount() throws {
        let reference = Reference(
            from: VerseReference(chapter: ChapterReference(bookName: .Genesis, index: 1), index: 1),
            to: VerseReference(chapter: ChapterReference(bookName: .Revelation, index: 22), index: 21)
        )

        #expect(reference.verseIDs().count == 31102)
    }

    /// Comprehensive test of each book's data in the Bible
    /// For each book, verifies:
    /// - Total number of chapters
    /// - Total number of verses
    /// Tests all 66 books of the Bible in order:
    /// - Old Testament (39 books)
    /// - New Testament (27 books)
    @Test func bookCollection() throws {
        // Old Testament
        let genesisBook = BookCollection.mapping[.Genesis]!
        #expect(genesisBook.totalChapters == 50)
        #expect(genesisBook.allVerseIDs().count == 1533)
        let exodusBook = BookCollection.mapping[.Exodus]!
        #expect(exodusBook.totalChapters == 40)
        #expect(exodusBook.allVerseIDs().count == 1213)
        let leviticusBook = BookCollection.mapping[.Leviticus]!
        #expect(leviticusBook.totalChapters == 27)
        #expect(leviticusBook.allVerseIDs().count == 859)
        let numbersBook = BookCollection.mapping[.Numbers]!
        #expect(numbersBook.totalChapters == 36)
        #expect(numbersBook.allVerseIDs().count == 1288)
        let deuteronomyBook = BookCollection.mapping[.Deuteronomy]!
        #expect(deuteronomyBook.totalChapters == 34)
        #expect(deuteronomyBook.allVerseIDs().count == 959)

        let joshuaBook = BookCollection.mapping[.Joshua]!
        #expect(joshuaBook.totalChapters == 24)
        #expect(joshuaBook.allVerseIDs().count == 658)
        let judgesBook = BookCollection.mapping[.Judges]!
        #expect(judgesBook.totalChapters == 21)
        #expect(judgesBook.allVerseIDs().count == 618)
        let ruthBook = BookCollection.mapping[.Ruth]!
        #expect(ruthBook.totalChapters == 4)
        #expect(ruthBook.allVerseIDs().count == 85)
        let samuel1Book = BookCollection.mapping[.Samuel1]!
        #expect(samuel1Book.totalChapters == 31)
        #expect(samuel1Book.allVerseIDs().count == 810)
        let samuel2Book = BookCollection.mapping[.Samuel2]!
        #expect(samuel2Book.totalChapters == 24)
        #expect(samuel2Book.allVerseIDs().count == 695)
        let kings1Book = BookCollection.mapping[.Kings1]!
        #expect(kings1Book.totalChapters == 22)
        #expect(kings1Book.allVerseIDs().count == 816)
        let kings2Book = BookCollection.mapping[.Kings2]!
        #expect(kings2Book.totalChapters == 25)
        #expect(kings2Book.allVerseIDs().count == 719)
        let chronicles1Book = BookCollection.mapping[.Chronicles1]!
        #expect(chronicles1Book.totalChapters == 29)
        #expect(chronicles1Book.allVerseIDs().count == 942)
        let chronicles2Book = BookCollection.mapping[.Chronicles2]!
        #expect(chronicles2Book.totalChapters == 36)
        #expect(chronicles2Book.allVerseIDs().count == 822)
        let ezraBook = BookCollection.mapping[.Ezra]!
        #expect(ezraBook.totalChapters == 10)
        #expect(ezraBook.allVerseIDs().count == 280)
        let nehemiahBook = BookCollection.mapping[.Nehemiah]!
        #expect(nehemiahBook.totalChapters == 13)
        #expect(nehemiahBook.allVerseIDs().count == 406)
        let estherBook = BookCollection.mapping[.Esther]!
        #expect(estherBook.totalChapters == 10)
        #expect(estherBook.allVerseIDs().count == 167)

        let jobBook = BookCollection.mapping[.Job]!
        #expect(jobBook.totalChapters == 42)
        #expect(jobBook.allVerseIDs().count == 1070)
        let psalmsBook = BookCollection.mapping[.Psalms]!
        #expect(psalmsBook.totalChapters == 150)
        #expect(psalmsBook.allVerseIDs().count == 2461)
        let proverbsBook = BookCollection.mapping[.Proverbs]!
        #expect(proverbsBook.totalChapters == 31)
        #expect(proverbsBook.allVerseIDs().count == 915)
        let ecclesiastesBook = BookCollection.mapping[.Ecclesiastes]!
        #expect(ecclesiastesBook.totalChapters == 12)
        #expect(ecclesiastesBook.allVerseIDs().count == 222)
        let songOfSolomonBook = BookCollection.mapping[.SongOfSolomon]!
        #expect(songOfSolomonBook.totalChapters == 8)
        #expect(songOfSolomonBook.allVerseIDs().count == 117)

        let isaiahBook = BookCollection.mapping[.Isaiah]!
        #expect(isaiahBook.totalChapters == 66)
        #expect(isaiahBook.allVerseIDs().count == 1292)
        let jeremiahBook = BookCollection.mapping[.Jeremiah]!
        #expect(jeremiahBook.totalChapters == 52)
        #expect(jeremiahBook.allVerseIDs().count == 1364)
        let lamentationsBook = BookCollection.mapping[.Lamentations]!
        #expect(lamentationsBook.totalChapters == 5)
        #expect(lamentationsBook.allVerseIDs().count == 154)
        let ezekielBook = BookCollection.mapping[.Ezekiel]!
        #expect(ezekielBook.totalChapters == 48)
        #expect(ezekielBook.allVerseIDs().count == 1273)
        let danielBook = BookCollection.mapping[.Daniel]!
        #expect(danielBook.totalChapters == 12)
        #expect(danielBook.allVerseIDs().count == 357)
        let hoseaBook = BookCollection.mapping[.Hosea]!
        #expect(hoseaBook.totalChapters == 14)
        #expect(hoseaBook.allVerseIDs().count == 197)
        let joelBook = BookCollection.mapping[.Joel]!
        #expect(joelBook.totalChapters == 3)
        #expect(joelBook.allVerseIDs().count == 73)
        let amosBook = BookCollection.mapping[.Amos]!
        #expect(amosBook.totalChapters == 9)
        #expect(amosBook.allVerseIDs().count == 146)
        let obadiahBook = BookCollection.mapping[.Obadiah]!
        #expect(obadiahBook.totalChapters == 1)
        #expect(obadiahBook.allVerseIDs().count == 21)
        let jonahBook = BookCollection.mapping[.Jonah]!
        #expect(jonahBook.totalChapters == 4)
        #expect(jonahBook.allVerseIDs().count == 48)
        let micahBook = BookCollection.mapping[.Micah]!
        #expect(micahBook.totalChapters == 7)
        #expect(micahBook.allVerseIDs().count == 105)
        let nahumBook = BookCollection.mapping[.Nahum]!
        #expect(nahumBook.totalChapters == 3)
        #expect(nahumBook.allVerseIDs().count == 47)
        let habakkukBook = BookCollection.mapping[.Habakkuk]!
        #expect(habakkukBook.totalChapters == 3)
        #expect(habakkukBook.allVerseIDs().count == 56)
        let zephaniahBook = BookCollection.mapping[.Zephaniah]!
        #expect(zephaniahBook.totalChapters == 3)
        #expect(zephaniahBook.allVerseIDs().count == 53)
        let haggaiBook = BookCollection.mapping[.Haggai]!
        #expect(haggaiBook.totalChapters == 2)
        #expect(haggaiBook.allVerseIDs().count == 38)
        let zechariahBook = BookCollection.mapping[.Zechariah]!
        #expect(zechariahBook.totalChapters == 14)
        #expect(zechariahBook.allVerseIDs().count == 211)
        let malachiBook = BookCollection.mapping[.Malachi]!
        #expect(malachiBook.totalChapters == 4)
        #expect(malachiBook.allVerseIDs().count == 55)

        // New Testament
        let matthewBook = BookCollection.mapping[.Matthew]!
        #expect(matthewBook.totalChapters == 28)
        #expect(matthewBook.allVerseIDs().count == 1071)
        let markBook = BookCollection.mapping[.Mark]!
        #expect(markBook.totalChapters == 16)
        #expect(markBook.allVerseIDs().count == 678)
        let lukeBook = BookCollection.mapping[.Luke]!
        #expect(lukeBook.totalChapters == 24)
        #expect(lukeBook.allVerseIDs().count == 1151)
        let johnBook = BookCollection.mapping[.John]!
        #expect(johnBook.totalChapters == 21)
        #expect(johnBook.allVerseIDs().count == 879)

        let actsBook = BookCollection.mapping[.Acts]!
        #expect(actsBook.totalChapters == 28)
        #expect(actsBook.allVerseIDs().count == 1007)

        let romansBook = BookCollection.mapping[.Romans]!
        #expect(romansBook.totalChapters == 16)
        #expect(romansBook.allVerseIDs().count == 433)
        let corinthians1Book = BookCollection.mapping[.Corinthians1]!
        #expect(corinthians1Book.totalChapters == 16)
        #expect(corinthians1Book.allVerseIDs().count == 437)
        let corinthians2Book = BookCollection.mapping[.Corinthians2]!
        #expect(corinthians2Book.totalChapters == 13)
        #expect(corinthians2Book.allVerseIDs().count == 257)

        let galatiansBook = BookCollection.mapping[.Galatians]!
        #expect(galatiansBook.totalChapters == 6)
        #expect(galatiansBook.allVerseIDs().count == 149)
        let ephesiansBook = BookCollection.mapping[.Ephesians]!
        #expect(ephesiansBook.totalChapters == 6)
        #expect(ephesiansBook.allVerseIDs().count == 155)
        let philippiansBook = BookCollection.mapping[.Philippians]!
        #expect(philippiansBook.totalChapters == 4)
        #expect(philippiansBook.allVerseIDs().count == 104)
        let colossiansBook = BookCollection.mapping[.Colossians]!
        #expect(colossiansBook.totalChapters == 4)
        #expect(colossiansBook.allVerseIDs().count == 95)

        let thessalonians1Book = BookCollection.mapping[.Thessalonians1]!
        #expect(thessalonians1Book.totalChapters == 5)
        #expect(thessalonians1Book.allVerseIDs().count == 89)
        let thessalonians2Book = BookCollection.mapping[.Thessalonians2]!
        #expect(thessalonians2Book.totalChapters == 3)
        #expect(thessalonians2Book.allVerseIDs().count == 47)
        let timothy1Book = BookCollection.mapping[.Timothy1]!
        #expect(timothy1Book.totalChapters == 6)
        #expect(timothy1Book.allVerseIDs().count == 113)
        let timothy2Book = BookCollection.mapping[.Timothy2]!
        #expect(timothy2Book.totalChapters == 4)
        #expect(timothy2Book.allVerseIDs().count == 83)
        let titusBook = BookCollection.mapping[.Titus]!
        #expect(titusBook.totalChapters == 3)
        #expect(titusBook.allVerseIDs().count == 46)

        let philemonBook = BookCollection.mapping[.Philemon]!
        #expect(philemonBook.totalChapters == 1)
        #expect(philemonBook.allVerseIDs().count == 25)
        let hebrewsBook = BookCollection.mapping[.Hebrews]!
        #expect(hebrewsBook.totalChapters == 13)
        #expect(hebrewsBook.allVerseIDs().count == 303)
        let jamesBook = BookCollection.mapping[.James]!
        #expect(jamesBook.totalChapters == 5)
        #expect(jamesBook.allVerseIDs().count == 108)

        let peter1Book = BookCollection.mapping[.Peter1]!
        #expect(peter1Book.totalChapters == 5)
        #expect(peter1Book.allVerseIDs().count == 105)
        let peter2Book = BookCollection.mapping[.Peter2]!
        #expect(peter2Book.totalChapters == 3)
        #expect(peter2Book.allVerseIDs().count == 61)

        let john1Book = BookCollection.mapping[.John1]!
        #expect(john1Book.totalChapters == 5)
        #expect(john1Book.allVerseIDs().count == 105)
        let john2Book = BookCollection.mapping[.John2]!
        #expect(john2Book.totalChapters == 1)
        #expect(john2Book.allVerseIDs().count == 13)
        let john3Book = BookCollection.mapping[.John3]!
        #expect(john3Book.totalChapters == 1)
        #expect(john3Book.allVerseIDs().count == 14)
        let judeBook = BookCollection.mapping[.Jude]!
        #expect(judeBook.totalChapters == 1)
        #expect(judeBook.allVerseIDs().count == 25)

        let revelationBook = BookCollection.mapping[.Revelation]!
        #expect(revelationBook.totalChapters == 22)
        #expect(revelationBook.allVerseIDs().count == 404)
    }
}
