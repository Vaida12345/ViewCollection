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
    ], products: [
        .library(name: "ViewCollection", targets: ["ViewCollection"]),
    ], dependencies: [
        .package(name: "Nucleus", 
                 path: "~/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Projects/Packages/DataBase"),
    ], targets: [
        .target(name: "ViewCollection", dependencies: ["Nucleus"]),
        .testTarget(name: "ViewCollectionTests", dependencies: ["ViewCollection"]),
    ]
)
