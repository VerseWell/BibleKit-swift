# BibleKit

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Documentation](https://img.shields.io/badge/docs-DocC-green)](https://versewell.github.io/BibleKit-swift)
[![codecov](https://codecov.io/gh/VerseWell/BibleKit-swift/branch/main/graph/badge.svg)](https://codecov.io/gh/VerseWell/BibleKit-swift)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

BibleKit is a Swift package that provides Bible-related functionality for iOS and macOS platforms.

## Features

- 🔍 Powerful verse search functionality
- 📚 Bible database access
- 📱 Support for iOS and macOS
- ⚡️ Built with Swift

## Requirements

- **iOS**: 13.0+
- **macOS**: 10.15+

## Installation

### Swift Package Manager

Add BibleKit to your project using [Swift Package Manager](https://swift.org/package-manager/):

```swift
.package(url: "https://github.com/VerseWell/BibleKit-swift.git", from: "0.2.0")
```

Then add `BibleKit` as a dependency in your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "BibleKit", package: "BibleKit-swift")
    ]
)
```

## Usage

> [!IMPORTANT]
> Your app must include a file named `bible.db` in its bundle. This SQLite database file contains the Bible content and is required for the library to function. You can find:
> - Example database file: [bible.db](iOSApp/iOSApp/bible.db) (World English Bible with [translation modifications](#bible-translation))
> - Database schema: [database.sq](Sources/BibleKitDB/VerseDataSource.swift#L44)
>
> You can replace the `bible.db` file with your preferred translation as long as it follows the same database schema.

### Swift

```swift
import BibleKit

// Create a provider with your bible.db file
let provider = BibleProvider.create(
    url: Bundle.main.url(forResource: "bible", withExtension: "db")!
)

// Search for verses containing a word
Task {
    let results = try await provider.search(query: "love")
    for verse in results {
        print(verse.id.bookChapterVerse(), verse.text)
    }
}
```

## Kotlin Multiplatform

For teams that need cross-platform support (Android, iOS, macOS), consider using [BibleKit KMP](https://github.com/VerseWell/biblekit-kmp), our Kotlin Multiplatform solution.

## Documentation

For detailed API documentation, visit [BibleKit Swift Documentation](https://versewell.github.io/BibleKit-swift).

## Bible Translation

The example database included with BibleKit uses the **World English Bible** translation (Protestant, US English) with **modifications**. 
- You can visit the [official WEB page](https://ebible.org/find/show.php?id=engwebp) for more information about this translation. 
- For details regarding the modifications we've made to the WEB translation in our database, please refer to our [Translation Modifications documentation](https://versewell.github.io/translation#translation-modifications).

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
