import Foundation

/// Service interface for accessing and retrieving Bible verses from a data store.
/// This interface defines the core operations needed to search and retrieve verses,
/// supporting both text-based search and direct verse access.
///
/// Implementations of this interface should:
/// - Handle database connections and queries efficiently
/// - Support pagination for large result sets
/// - Provide thread-safe access to the verse store
/// - Handle errors appropriately
protocol BibleStoreService: Sendable {
    /// Searches for verses containing specific text, optionally limited to a set of verse IDs.
    /// This method supports full-text search within the Bible database.
    ///
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - verseIDs: Optional list of verse IDs to limit the search scope (nil for entire Bible)
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: List of Verse objects matching the search criteria
    /// - Throws: Exception if there's an error accessing the data store
    func searchVerses(
        text: String,
        verseIDs: [VerseID]?,
        limit: Int,
        offset: Int
    ) async throws -> [Verse]

    /// Searches for verses containing specific text within a range of verse IDs (inclusive).
    /// This method provides efficient search within a verse range without requiring the full list of IDs.
    ///
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - startVerseID: The starting verse ID of the range
    ///   - endVerseID: The ending verse ID of the range
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: List of Verse objects matching the search criteria within the specified range
    /// - Throws: Exception if there's an error accessing the data store
    func searchVersesInRange(
        text: String,
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async throws -> [Verse]

    /// Retrieves specific verses by their IDs.
    /// This method provides direct access to verses without text search.
    ///
    /// - Parameters:
    ///   - verseIDs: List of verse IDs to retrieve
    ///   - limit: Maximum number of verses to return
    ///   - offset: Number of verses to skip for pagination
    /// - Returns: List of requested Verse objects in the order specified by verseIDs
    /// - Throws: Exception if there's an error accessing the data store
    func getVerses(
        verseIDs: [VerseID],
        limit: Int,
        offset: Int
    ) async throws -> [Verse]

    /// Retrieves verses between two verse IDs (inclusive).
    /// This method provides efficient access to a range of verses without requiring the full list of IDs.
    ///
    /// - Parameters:
    ///   - startVerseID: The starting verse ID of the range
    ///   - endVerseID: The ending verse ID of the range
    ///   - limit: Maximum number of verses to return
    ///   - offset: Number of verses to skip for pagination
    /// - Returns: List of Verse objects between startVerseID and endVerseID (inclusive)
    /// - Throws: Exception if there's an error accessing the data store
    func getVersesInRange(
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async throws -> [Verse]
}
