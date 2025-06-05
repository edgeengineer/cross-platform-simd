// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "CrossPlatformSIMD",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        .macCatalyst(.v15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "CrossPlatformSIMD",
            targets: ["CrossPlatformSIMD"]),
    ],
    targets: [
        .target(
            name: "CrossPlatformSIMD",
            dependencies: [],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "CrossPlatformSIMDTests",
            dependencies: ["CrossPlatformSIMD"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)