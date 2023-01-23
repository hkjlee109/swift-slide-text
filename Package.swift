// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-slide-text",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SlideText",
            targets: ["SlideText"]),
        .library(
            name: "UISlideLabel",
            targets: ["UISlideLabel"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SlideText",
            dependencies: []),
        .target(
            name: "UISlideLabel",
            dependencies: []),
        .testTarget(
            name: "SlideTextTests",
            dependencies: ["SlideText"]),
    ]
)
