import BibleKitDB
import Foundation

/// Default implementation of BibleStoreService that wraps BibleStoreProvider.
/// This class serves as an adapter between the database layer and the domain layer,
/// converting between database entities and domain models.
///
/// Features:
/// - Converts between VerseID and String representations
/// - Maps database VerseEntity to domain Verse objects
/// - Handles pagination and search operations
final class DefaultBibleStoreService: BibleStoreService, Sendable {
    private let provider: BibleStoreProvider

    init(provider: BibleStoreProvider) {
        self.provider = provider
    }

    /// Searches for verses containing specific text, optionally limited to a set of verse IDs.
    ///
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - verseIDs: Optional list of verse IDs to limit the search scope
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: List of matching Verse objects
    func searchVerses(
        text: String,
        verseIDs: [VerseID]?,
        limit: Int,
        offset: Int
    ) async throws -> [Verse] {
        let verseIDStrings = verseIDs?.map(\.value)
        let results = try await provider.searchVerses(
            text: text,
            verseIDs: verseIDStrings,
            limit: limit,
            offset: offset
        )

        return results.map { entity in
            Verse(
                id: VerseID(value: entity.id),
                text: entity.text
            )
        }
    }

    /// Searches for verses containing specific text within a range of verse IDs.
    ///
    /// - Parameters:
    ///   - text: The text to search for within verses
    ///   - startVerseID: The starting verse ID of the range
    ///   - endVerseID: The ending verse ID of the range
    ///   - limit: Maximum number of results to return
    ///   - offset: Number of results to skip for pagination
    /// - Returns: List of matching Verse objects within the specified range
    func searchVersesInRange(
        text: String,
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async throws -> [Verse] {
        let results = try await provider.searchVersesInRange(
            text: text,
            startVerse: startVerseID.value,
            endVerse: endVerseID.value,
            limit: limit,
            offset: offset
        )

        return results.map { entity in
            Verse(
                id: VerseID(value: entity.id),
                text: entity.text
            )
        }
    }

    /// Retrieves specific verses by their IDs.
    ///
    /// - Parameters:
    ///   - verseIDs: List of verse IDs to retrieve
    ///   - limit: Maximum number of verses to return
    ///   - offset: Number of verses to skip for pagination
    /// - Returns: List of requested Verse objects
    func getVerses(
        verseIDs: [VerseID],
        limit: Int,
        offset: Int
    ) async throws -> [Verse] {
        let verseIDStrings = verseIDs.map(\.value)
        let results = try await provider.getVerses(
            verseIDs: verseIDStrings,
            limit: limit,
            offset: offset
        )

        return results.map { entity in
            Verse(
                id: VerseID(value: entity.id),
                text: entity.text
            )
        }
    }

    /// Retrieves verses between two verse IDs (inclusive).
    ///
    /// - Parameters:
    ///   - startVerseID: The starting verse ID of the range
    ///   - endVerseID: The ending verse ID of the range
    ///   - limit: Maximum number of verses to return
    ///   - offset: Number of verses to skip for pagination
    /// - Returns: List of Verse objects between startVerseID and endVerseID
    func getVersesInRange(
        startVerseID: VerseID,
        endVerseID: VerseID,
        limit: Int,
        offset: Int
    ) async throws -> [Verse] {
        let results = try await provider.getVersesInRange(
            startVerse: startVerseID.value,
            endVerse: endVerseID.value,
            limit: limit,
            offset: offset
        )

        return results.map { entity in
            Verse(
                id: VerseID(value: entity.id),
                text: entity.text
            )
        }
    }
}
