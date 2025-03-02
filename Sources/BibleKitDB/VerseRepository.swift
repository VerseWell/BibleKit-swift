import Foundation

/// The Repository for accessing VerseEntity objects.
public protocol VerseRepository: Sendable {
    /// Returns a list of verses matching the text with pagination support
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects matching the text
    func searchVerses(text: String, limit: Int, offset: Int) async throws -> [VerseEntity]

    /// Returns a list of VerseEntity objects within the specified verse range that contain the search text
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects matching both the range and search text
    func searchVersesInRange(
        text: String,
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity]

    /// Returns a list of verses matching the provided IDs with search text
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - verseIDs: Array of specific verse IDs to search within
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects matching both the IDs and text
    /// - Throws: Database errors if the query fails
    func searchVersesByIds(
        text: String,
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity]

    /// Returns a list of verses matching the provided IDs
    /// - Parameters:
    ///   - verseIDs: Array of specific verse IDs to retrieve
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects with the matching IDs
    /// - Throws: Database errors if the query fails
    func getVersesByIds(
        verseIDs: [String],
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity]

    /// Returns a list of VerseEntity objects within the specified verse range
    /// - Parameters:
    ///   - startVerse: The starting verse ID (inclusive)
    ///   - endVerse: The ending verse ID (inclusive)
    ///   - limit: The maximum number of results to return
    ///   - offset: The offset for paginated results
    /// - Returns: An array of VerseEntity objects within the specified range
    func getVersesInRange(
        startVerse: String,
        endVerse: String,
        limit: Int,
        offset: Int
    ) async throws -> [VerseEntity]

    /// Inserts a list of verses into the database
    /// - Parameter verses: The list of VerseEntity objects to insert
    func insertVerses(_ verses: [VerseEntity]) async throws
}
