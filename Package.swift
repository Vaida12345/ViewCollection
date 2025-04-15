// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package (
    name: "ViewCollection",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .visionOS(.v2)
    ], products: [
        .library(name: "ViewCollection", targets: ["ViewCollection", "SoftUI"]),
    ], dependencies: [
        .package(url: "https://www.github.com/Vaida12345/NativeImage", from: "1.0.0"),
        .package(url: "https://www.github.com/Vaida12345/FinderItem", from: "1.0.7"),
        .package(url: "https://www.github.com/Vaida12345/Matrix", branch: "main")
    ], targets: [
        .target(name: "ViewCollection", dependencies: ["NativeImage", "Matrix", "FinderItem"], path: "Sources"),
        .target(name: "SoftUI", dependencies: ["ViewCollection"], path: "SoftUI")
    ]
)
