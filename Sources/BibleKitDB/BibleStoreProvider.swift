import Foundation

/// A service class that provides access to Bible verse data by interfacing with a VerseRepository.
/// This class handles searching and retrieving verses based on various criteria like IDs and text content.
public final class BibleStoreProvider: Sendable {
    /// The repository instance responsible for data access operations.
    /// This handles the actual database interactions for verse retrieval.
    private let repository: VerseRepository

    /// Initializes a new BibleStoreProvider with a verse repository.
    /// - Parameter repository: The repository implementation to use for verse data access
    public init(repository: VerseRepository) {
        self.repository = repository
    }

    /// Creates a new BibleStoreProvider instance configured for a specific Bible translation.
    /// - Parameter url: The file URL pointing to the SQLite database containing Bible verse data
    /// - Returns: A configured BibleStoreProvider instance ready for use
    public static func create(url: URL) -> BibleStoreProvider {
        let repository = VerseDataSource(url: url)
        return BibleStoreProvider(repository: repository)
    }

    /// Searches for verses containing the specified text within a specified range.
    ///
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects matching the search criteria within the range
    /// - Throws: Any errors encountered during the database operation
    public func searchVersesInRange(
        text: String,
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        try await repository.searchVersesInRange(
            text: text,
            startVerse: startVerse,
            endVerse: endVerse,
            limit: limit,
            offset: offset
        )
    }

    /// Searches for verses containing the specified text on the provided verse IDs or the entire bible.
    ///
    /// - Parameters:
    ///   - text: The search text to match against verse content
    ///   - verseIDs: Optional array of specific verse IDs to search within. If nil, searches all verses
    ///   - limit: Maximum number of verses to return in the results
    ///   - offset: Number of verses to skip for pagination
    /// - Returns: An array of matching VerseEntity objects
    /// - Throws: Any errors encountered during the database operation
    public func searchVerses(
        text: String,
        verseIDs: [String]? = nil,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        if let verseIDs {
            try await repository.searchVersesByIds(
                text: text,
                verseIDs: verseIDs,
                limit: limit,
                offset: offset
            )
        } else {
            try await repository.searchVerses(
                text: text,
                limit: limit,
                offset: offset
            )
        }
    }

    /// Retrieves Bible verses within a specified range.
    ///
    /// - Parameters:
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects within the specified range
    /// - Throws: Any errors encountered during the database operation
    public func getVersesInRange(
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        try await repository.getVersesInRange(
            startVerse: startVerse,
            endVerse: endVerse,
            limit: limit,
            offset: offset
        )
    }

    /// Retrieves Bible verses based on the provided verse IDs.
    ///
    /// - Parameters:
    ///   - verseIDs: An array of verse IDs to retrieve
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects
    /// - Throws: Any errors encountered during the database operation
    public func getVerses(
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity] {
        try await repository.getVersesByIds(
            verseIDs: verseIDs,
            limit: limit,
            offset: offset
        )
    }
}
