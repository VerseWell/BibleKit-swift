import Foundation
import GRDB

/// A data source implementation of VerseRepository that uses GRDB for database access.
/// This class handles the persistence and retrieval of Bible verses using SQLite through GRDB.
final class VerseDataSource: VerseRepository, Sendable {
    /// Database model representing a Bible verse with its metadata and content.
    /// Conforms to necessary GRDB protocols for database operations.
    struct Verse: Codable, FetchableRecord, PersistableRecord {
        var id: Int
        var number: String
        var text: String
        var searchText: String

        /// Database column definitions for type-safe queries
        enum Columns {
            static let id = Column(CodingKeys.id)
            static let number = Column(CodingKeys.number)
            static let text = Column(CodingKeys.text)
            static let searchText = Column(CodingKeys.searchText)
        }
    }

    /// The database writer instance used for all database operations
    private let databaseWriter: DatabaseWriter

    /// Creates a new instance of VerseDataSource with a custom database writer
    /// - Parameter databaseWriter: The DatabaseWriter instance to use for database access
    init(databaseWriter: DatabaseWriter) {
        self.databaseWriter = databaseWriter
    }

    /// Creates a new instance of VerseDataSource for a specific Bible database
    /// - Parameter url: The file URL pointing to the SQLite database file
    convenience init(url: URL) {
        self.init(databaseWriter: try! DatabaseQueue(path: url.path))
    }

    /// Creates a new instance of VerseDataSource with an in-memory database
    /// Useful for testing or temporary storage scenarios
    /// - Parameter dbQueue: Optional custom DatabaseQueue, defaults to new in-memory queue
    /// - Returns: A configured VerseDataSource instance with initialized schema
    /// - Throws: Database errors if schema creation fails
    static func create(dbQueue: DatabaseQueue = try! DatabaseQueue()) async throws -> VerseDataSource {
        try await dbQueue.write { db in
            try db.create(table: "Verse") { t in
                t.column("id", .integer).primaryKey()
                t.column("number", .text).unique().indexed().notNull()
                t.column("text", .text).notNull()
                t.column("searchText", .text).indexed().notNull()
            }

            try db.create(virtualTable: "VerseFts", using: FTS5()) { t in
                t.tokenizer = .porter(wrapping: .unicode61())
                t.content = "Verse"
                t.column("searchText")
                t.synchronize(withTable: "Verse")
            }
        }

        return VerseDataSource(databaseWriter: dbQueue)
    }

    /// Retrieves verses containing the specified text
    /// Results are prioritized: exact phrase matches first (ordered by verse id),
    /// then word matches (ordered by relevance)
    /// - Parameters:
    ///   - text: The text to search for in verses
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: Array of matching VerseEntity objects
    /// - Throws: Database errors if the query fails
    func searchVerses(text: String, limit: Int, offset: Int) async throws -> [VerseEntity] {
        try await databaseWriter.read { db in
            let phraseSearchTerm = "\"\(text)\""
            let request: SQLRequest<Verse> = """
            SELECT id, number, text, searchText FROM (
                -- First: Exact phrase matches (ordered by verse order)
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    0 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(phraseSearchTerm)
                ) AS exact_matches ON Verse.id = exact_matches.rowid

                UNION

                -- Second: All words present but not as exact phrase
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    1 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(text)
                ) AS word_matches ON Verse.id = word_matches.rowid
                WHERE Verse.id NOT IN (
                    SELECT Verse.id
                    FROM Verse
                    JOIN VerseFts ON Verse.id = VerseFts.rowid
                    WHERE VerseFts.searchText MATCH \(phraseSearchTerm)
                )
            )
            ORDER BY priority, id
            LIMIT \(limit) OFFSET \(offset)
            """
            let records = try request.fetchAll(db)
            return records
                .map { VerseEntity(id: $0.number, text: $0.text) }
        }
    }

    /// Retrieves verses with specific IDs that contain the search text
    /// Results are prioritized: exact phrase matches first (ordered by verse id),
    /// then word matches (ordered by relevance)
    /// - Parameters:
    ///   - text: The text to search for in verses
    ///   - verseIDs: Array of specific verse IDs to search within.
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: Array of matching VerseEntity objects
    /// - Throws: Database errors if the query fails
    func searchVersesByIds(
        text: String,
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        let verseIDKeys = verseIDs.map { VerseEntity.sortKey(id: $0) }
        return try await databaseWriter.read { db in
            let phraseSearchTerm = "\"\(text)\""
            let request: SQLRequest<Verse> = """
            SELECT id, number, text, searchText FROM (
                -- First: Exact phrase matches (ordered by verse order)
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    0 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(phraseSearchTerm)
                ) AS exact_matches ON Verse.id = exact_matches.rowid
                WHERE Verse.id IN \(verseIDKeys)

                UNION

                -- Second: All words present but not as exact phrase
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    1 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(text)
                ) AS word_matches ON Verse.id = word_matches.rowid
                WHERE Verse.id IN \(verseIDKeys)
                AND Verse.id NOT IN (
                    SELECT Verse.id
                    FROM Verse
                    JOIN VerseFts ON Verse.id = VerseFts.rowid
                    WHERE VerseFts.searchText MATCH \(phraseSearchTerm)
                )
            )
            ORDER BY priority, id
            LIMIT \(limit) OFFSET \(offset)
            """
            let records = try request.fetchAll(db)
            return records.map {
                VerseEntity(id: $0.number, text: $0.text)
            }
        }
    }

    /// Retrieves verses with specific IDs
    /// - Parameters:
    ///   - verseIDs: Array of specific verse IDs to fetch.
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: Array of matching VerseEntity objects
    /// - Throws: Database errors if the query fails
    func getVersesByIds(
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        let verseIDKeys = verseIDs.map { VerseEntity.sortKey(id: $0) }
        return try await databaseWriter.read { db in
            let request: SQLRequest<Verse> = "SELECT Verse.id, Verse.number, Verse.text, Verse.searchText FROM Verse WHERE Verse.id IN \(verseIDKeys) ORDER BY Verse.id LIMIT \(limit) OFFSET \(offset)"
            let records = try request.fetchAll(db)
            return records.map {
                VerseEntity(id: $0.number, text: $0.text)
            }
        }
    }

    /// Searches for verses containing the specified text within a verse range
    /// Results are prioritized: exact phrase matches first (ordered by verse id),
    /// then word matches (ordered by relevance)
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: Array of matching VerseEntity objects within the range
    /// - Throws: Database errors if the query fails
    func searchVersesInRange(
        text: String,
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        let start = VerseEntity(id: startVerse, text: "").key
        let end = VerseEntity(id: endVerse, text: "").key

        return try await databaseWriter.read { db in
            let phraseSearchTerm = "\"\(text)\""
            let request: SQLRequest<Verse> = """
            SELECT id, number, text, searchText FROM (
                -- First: Exact phrase matches (ordered by verse order)
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    0 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(phraseSearchTerm)
                ) AS exact_matches ON Verse.id = exact_matches.rowid
                WHERE Verse.id BETWEEN \(start) AND \(end)

                UNION

                -- Second: All words present but not as exact phrase
                SELECT
                    Verse.id,
                    Verse.number,
                    Verse.text,
                    Verse.searchText,
                    1 AS priority
                FROM Verse
                JOIN (
                    SELECT rowid
                    FROM VerseFts
                    WHERE searchText MATCH \(text)
                ) AS word_matches ON Verse.id = word_matches.rowid
                WHERE Verse.id BETWEEN \(start) AND \(end)
                AND Verse.id NOT IN (
                    SELECT Verse.id
                    FROM Verse
                    JOIN VerseFts ON Verse.id = VerseFts.rowid
                    WHERE VerseFts.searchText MATCH \(phraseSearchTerm)
                )
            )
            ORDER BY priority, id
            LIMIT \(limit) OFFSET \(offset)
            """
            let records = try request.fetchAll(db)
            return records.map {
                VerseEntity(id: $0.number, text: $0.text)
            }
        }
    }

    /// Retrieves verses within a specified range
    /// - Parameters:
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: Array of VerseEntity objects within the range
    /// - Throws: Database errors if the query fails
    func getVersesInRange(
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        let start = VerseEntity(id: startVerse, text: "").key
        let end = VerseEntity(id: endVerse, text: "").key

        return try await databaseWriter.read { db in
            let request: SQLRequest<Verse> = "SELECT Verse.id, Verse.number, Verse.text, Verse.searchText FROM Verse WHERE Verse.id BETWEEN \(start) AND \(end) ORDER BY Verse.id LIMIT \(limit) OFFSET \(offset)"
            let records = try request.fetchAll(db)
            return records.map {
                VerseEntity(id: $0.number, text: $0.text)
            }
        }
    }

    /// Inserts multiple verses into the database
    /// - Parameter verses: Array of VerseEntity objects to insert
    /// - Throws: Database errors if the insertion fails
    func insertVerses(_ verses: [VerseEntity]) async throws {
        try await databaseWriter.write { db in
            let bibleVerses = verses.map { verse in
                Verse(id: verse.key, number: verse.id, text: verse.text, searchText: verse.text)
            }
            try bibleVerses.forEach { try $0.insert(db) }
        }
    }
}
