// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package (
    name: "ViewCollection",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ], products: [
        .library(name: "ViewCollection", targets: ["ViewCollection"]),
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/NativeImage.git", from: "1.0.0"),
        .package(url: "https://github.com/Vaida12345/Matrix.git", from: "1.0.0")
    ], targets: [
        .target(name: "ViewCollection", dependencies: ["NativeImage", "Matrix"], path: "Sources"),
    ], swiftLanguageModes: [.v5]
)
