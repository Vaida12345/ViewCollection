// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package (
    name: "ViewCollection",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .visionOS(.v2)
    ], products: [
        .library(name: "ViewCollection", targets: ["ViewCollection", "SoftUI"]),
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/NativeImage.git", from: "1.3.0"),
        .package(url: "https://github.com/Vaida12345/FinderItem.git", from: "2.0.1"),
        .package(url: "https://github.com/Vaida12345/Essentials.git", from: "1.1.8"),
    ], targets: [
        .target(name: "ViewCollection", dependencies: ["NativeImage", "FinderItem", "Essentials"], path: "Sources"),
        .target(name: "SoftUI", dependencies: ["ViewCollection"], path: "SoftUI"),
        .testTarget(name: "Tests", dependencies: ["ViewCollection"], path: "Tests")
    ]
)
