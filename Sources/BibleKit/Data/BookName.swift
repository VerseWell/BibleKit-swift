import Foundation

/// Represents the canonical books of the Bible in their traditional order.
/// This enum provides both full names and standardized abbreviations for all 66 books,
/// divided into the Old Testament (Genesis through Malachi) and
/// New Testament (Matthew through Revelation).
///
/// Each book has:
/// - A full name (e.g., "Genesis", "1 Corinthians")
/// - A standardized abbreviation (e.g., "Gen", "1Co")
///
/// - Parameter value: The full name of the book
/// - Parameter shortName: The standardized abbreviation for the book
public enum BookName: String, CaseIterable, Equatable, Sendable {
    // Old Testament Books (1-39)
    case Genesis
    case Exodus
    case Leviticus
    case Numbers
    case Deuteronomy
    case Joshua
    case Judges
    case Ruth
    case Samuel1 = "1 Samuel"
    case Samuel2 = "2 Samuel"
    case Kings1 = "1 Kings"
    case Kings2 = "2 Kings"
    case Chronicles1 = "1 Chronicles"
    case Chronicles2 = "2 Chronicles"
    case Ezra
    case Nehemiah
    case Esther
    case Job
    case Psalms
    case Proverbs
    case Ecclesiastes
    case SongOfSolomon = "Song of Solomon"
    case Isaiah
    case Jeremiah
    case Lamentations
    case Ezekiel
    case Daniel
    case Hosea
    case Joel
    case Amos
    case Obadiah
    case Jonah
    case Micah
    case Nahum
    case Habakkuk
    case Zephaniah
    case Haggai
    case Zechariah
    case Malachi

    // New Testament Books (40-66)
    case Matthew
    case Mark
    case Luke
    case John
    case Acts
    case Romans
    case Corinthians1 = "1 Corinthians"
    case Corinthians2 = "2 Corinthians"
    case Galatians
    case Ephesians
    case Philippians
    case Colossians
    case Thessalonians1 = "1 Thessalonians"
    case Thessalonians2 = "2 Thessalonians"
    case Timothy1 = "1 Timothy"
    case Timothy2 = "2 Timothy"
    case Titus
    case Philemon
    case Hebrews
    case James
    case Peter1 = "1 Peter"
    case Peter2 = "2 Peter"
    case John1 = "1 John"
    case John2 = "2 John"
    case John3 = "3 John"
    case Jude
    case Revelation
}

// MARK: - BookName Properties

extension BookName {
    /// The full name of the book (e.g., "Genesis").
    public var value: String {
        self.rawValue
    }

    /// The standardized abbreviation for the book.
    public var shortName: String {
        switch self {
        case .Genesis: "Gen"
        case .Exodus: "Exo"
        case .Leviticus: "Lev"
        case .Numbers: "Num"
        case .Deuteronomy: "Deu"
        case .Joshua: "Jos"
        case .Judges: "Judg"
        case .Ruth: "Rth"
        case .Samuel1: "1Sa"
        case .Samuel2: "2Sa"
        case .Kings1: "1Ki"
        case .Kings2: "2Ki"
        case .Chronicles1: "1Ch"
        case .Chronicles2: "2Ch"
        case .Ezra: "Eza"
        case .Nehemiah: "Neh"
        case .Esther: "Est"
        case .Job: "Job"
        case .Psalms: "Psa"
        case .Proverbs: "Pro"
        case .Ecclesiastes: "Ecc"
        case .SongOfSolomon: "SS"
        case .Isaiah: "Isa"
        case .Jeremiah: "Jer"
        case .Lamentations: "Lam"
        case .Ezekiel: "Ezk"
        case .Daniel: "Dan"
        case .Hosea: "Hos"
        case .Joel: "Joe"
        case .Amos: "Amo"
        case .Obadiah: "Obd"
        case .Jonah: "Jon"
        case .Micah: "Mic"
        case .Nahum: "Nah"
        case .Habakkuk: "Hab"
        case .Zephaniah: "Zep"
        case .Haggai: "Hag"
        case .Zechariah: "Zch"
        case .Malachi: "Mal"
        case .Matthew: "Mat"
        case .Mark: "Mar"
        case .Luke: "Luk"
        case .John: "Jn"
        case .Acts: "Act"
        case .Romans: "Rom"
        case .Corinthians1: "1Co"
        case .Corinthians2: "2Co"
        case .Galatians: "Gal"
        case .Ephesians: "Eph"
        case .Philippians: "Phi"
        case .Colossians: "Col"
        case .Thessalonians1: "1Th"
        case .Thessalonians2: "2Th"
        case .Timothy1: "1Ti"
        case .Timothy2: "2Ti"
        case .Titus: "Tit"
        case .Philemon: "Phm"
        case .Hebrews: "Heb"
        case .James: "Jam"
        case .Peter1: "1Pe"
        case .Peter2: "2Pe"
        case .John1: "1Jo"
        case .John2: "2Jo"
        case .John3: "3Jo"
        case .Jude: "Jud"
        case .Revelation: "Rev"
        }
    }
}
