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
        .library(name: "ViewCollection", targets: ["ViewCollection"]),
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/NativeImage.git", from: "1.3.0"),
        .package(url: "https://github.com/Vaida12345/FinderItem.git", from: "2.2.4"),
        .package(url: "https://github.com/Vaida12345/Essentials.git", from: "1.5.0"),
        .package(url: "https://github.com/Vaida12345/ColorComponents.git", from: "1.1.0"),
    ], targets: [
        .target(name: "ViewCollection", dependencies: ["NativeImage", "FinderItem", "Essentials", "ColorComponents"], path: "Sources"),
        .testTarget(name: "Tests", dependencies: ["ViewCollection"], path: "Tests")
    ]
)
