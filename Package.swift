// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BibleKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "BibleKit",
            targets: ["BibleKit"]
        ),
        .library(
            name: "BibleKitDB",
            targets: ["BibleKitDB"]
        ),
    ],
    dependencies: {
        var dependencies: [Package.Dependency] = [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.0.0"),
        ]
        #if !os(iOS)
        dependencies.append(contentsOf: [
            .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        ])
        #endif
        return dependencies
    }(),
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BibleKit",
            dependencies: [
                "BibleKitDB",
            ]
        ),
        .testTarget(
            name: "BibleKitTests",
            dependencies: ["BibleKit"]
        ),
        .target(
            name: "BibleKitDB",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
            ]
        ),
        .testTarget(
            name: "BibleKitDBTests",
            dependencies: ["BibleKitDB"]
        ),
    ]
)
