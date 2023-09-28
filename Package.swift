// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SemanticContainerStyling",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "SemanticContainerStyling", targets: ["SemanticContainerStyling"]),
    ],
    targets: [
        .target(name: "SemanticContainerStyling"),
    ]
)
