import BibleKitDB
import Foundation

/// Main provider class for accessing and searching Bible content.
/// This class serves as the primary interface for retrieving verses and performing searches
/// within the Bible database.
///
/// Features:
/// - Full-text search with different search types (word, substring, prefix, suffix)
/// - Verse retrieval by chapter, book, or specific verse IDs
/// - Support for paginated results
/// - Reference-based search scoping
public final class BibleProvider: Sendable {
    private let store: BibleStoreService

    /// Initializes a new BibleProvider with the given BibleStoreService.
    /// - Parameter store: The service used to access Bible data.
    init(store: BibleStoreService) {
        self.store = store
    }

    /// Creates a new instance of BibleProvider with a default BibleStoreService implementation.
    /// This factory method sets up the database connection and wraps it with the appropriate service layer.
    ///
    /// - Parameter url: The file URL pointing to the SQLite database containing Bible verse data
    /// - Returns: A new BibleProvider instance ready for use
    public static func create(url: URL) -> BibleProvider {
        let provider = BibleStoreProvider.create(url: url)
        return BibleProvider(store: DefaultBibleStoreService(provider: provider))
    }

    /// Performs a text search across Bible verses with optional verse ID filtering.
    /// The search can be customized using different search types and supports pagination.
    /// If verseIDs is provided, the search will be limited to only those verses.
    ///
    /// - Parameters:
    ///   - query: The text to search for within verses
    ///   - verseIDs: Optional list of specific verse IDs to search within, if nil searches all verses
    ///   - limit: Maximum number of results to return (default: Int.max)
    ///   - offset: Number of results to skip for pagination (default: Int.min)
    /// - Returns: List of Verse objects matching the search criteria
    /// - Throws: Exception if there's an error accessing the database
    public func search(
        query: String,
        verseIDs: [VerseID]? = nil,
        limit: Int = Int.max,
        offset: Int = Int.min
    ) async throws -> [Verse] {
        // Return an empty list if the query is empty or contains only whitespace
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return []
        }

        return try await store.searchVerses(
            text: query,
            verseIDs: verseIDs,
            limit: limit,
            offset: offset
        )
    }

    /// Performs a text search within a specific range of verses defined by start and end verse IDs.
    /// This is a more direct way to search within a specific range compared to using Reference.
    ///
    /// - Parameters:
    ///   - query: The text to search for within verses
    ///   - reference: The Reference defining the range to search within
    ///   - limit: Maximum number of results to return (default: Int.max)
    ///   - offset: Number of results to skip for pagination (default: Int.min)
    /// - Returns: List of Verse objects matching the search criteria within the specified range
    /// - Throws: Exception if there's an error accessing the database
    public func search(
        query: String,
        reference: Reference,
        limit: Int = Int.max,
        offset: Int = Int.min
    ) async throws -> [Verse] {
        // Return an empty list if the query is empty or contains only whitespace
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return []
        }

        // Ensure the verse range is in the correct order (from <= to)
        let fixedReference = reference.fixup()

        return try await store.searchVersesInRange(
            text: query,
            startVerseID: fixedReference.from.verseID(),
            endVerseID: fixedReference.to.verseID(),
            limit: limit,
            offset: offset
        )
    }

    /// Retrieves all verses from a specific chapter.
    ///
    /// - Parameters:
    ///   - chapter: The ChapterReference specifying which chapter to retrieve
    ///   - limit: Maximum number of verses to return (default: Int.max)
    ///   - offset: Number of verses to skip (default: Int.min)
    /// - Returns: List of Verse objects from the specified chapter
    /// - Throws: Exception if there's an error accessing the database
    public func chapter(
        chapter: ChapterReference,
        limit: Int = Int.max,
        offset: Int = Int.min
    ) async throws -> [Verse] {
        try await store.getVersesInRange(
            startVerseID: chapter.startVerseID,
            endVerseID: chapter.endVerseID,
            limit: limit,
            offset: offset
        )
    }

    /// Retrieves all verses from a specific book of the Bible.
    ///
    /// - Parameters:
    ///   - book: The Book to retrieve verses from
    ///   - limit: Maximum number of verses to return (default: Int.max)
    ///   - offset: Number of verses to skip (default: Int.min)
    /// - Returns: List of Verse objects from the specified book
    /// - Throws: Exception if there's an error accessing the database
    public func book(
        book: Book,
        limit: Int = Int.max,
        offset: Int = Int.min
    ) async throws -> [Verse] {
        try await store.getVersesInRange(
            startVerseID: book.startVerseID,
            endVerseID: book.endVerseID,
            limit: limit,
            offset: offset
        )
    }

    /// Retrieves specific verses by their IDs.
    ///
    /// - Parameters:
    ///   - ids: List of VerseID objects identifying the verses to retrieve
    ///   - limit: Maximum number of verses to return (default: Int.max)
    ///   - offset: Number of verses to skip (default: Int.min)
    /// - Returns: List of requested Verse objects
    /// - Throws: Exception if there's an error accessing the database
    public func verses(
        ids: [VerseID],
        limit: Int = Int.max,
        offset: Int = Int.min
    ) async throws -> [Verse] {
        try await store.getVerses(
            verseIDs: ids,
            limit: limit,
            offset: offset
        )
    }
}
