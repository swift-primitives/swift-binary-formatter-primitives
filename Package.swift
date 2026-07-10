// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-binary-formatter-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Library
        .library(
            name: "Binary Formatter Primitives",
            targets: ["Binary Formatter Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Binary Formatter Primitives Test Support",
            targets: ["Binary Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-binary-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-formatter-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-formatter-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Byte-stream hex formatting
        //
        // `Binary.Formatter` — renders a stream of bytes (any `Collection` of
        // `Byte`) as hexadecimal text, composing `Byte.Formatter` per byte rather
        // than re-implementing hex. Grouping is controlled by a separator
        // (continuous "deadbeef" vs spaced "de ad be ef"); the base / digit
        // alphabet / case flow through from the composed per-byte formatter.
        // Depends on `Binary` (for the namespace), `Byte.Formatter` (per-byte hex),
        // and the `Formatter.Protocol` capability.
        .target(
            name: "Binary Formatter Primitives",
            dependencies: [
                .product(name: "Binary Primitive", package: "swift-binary-primitives"),
                .product(name: "Byte Formatter Primitives", package: "swift-byte-formatter-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Binary Formatter Primitives Test Support",
            dependencies: [
                "Binary Formatter Primitives",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
        .testTarget(
            name: "Binary Formatter Primitives Tests",
            dependencies: [
                "Binary Formatter Primitives",
                "Binary Formatter Primitives Test Support",
            ],
            path: "Tests/Binary Formatter Primitives Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
