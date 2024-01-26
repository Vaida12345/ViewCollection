// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewCollection",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ViewCollection",
            targets: ["ViewCollection"]),
    ],
    dependencies: [
        .package(name: "Nucleus", path: "~/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Projects/Packages/DataBase"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ViewCollection",
            dependencies: ["Nucleus"]),
        .testTarget(
            name: "ViewCollectionTests",
            dependencies: ["ViewCollection"]),
    ]
)
