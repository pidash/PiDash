// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

internal let package = Package(
    name: "BlueCom",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BlueCom",
            targets: ["BlueCom"])
    ],
    dependencies: [
        .package(path: "../Serializable")
    ],
    targets: [
        .target(
            name: "BlueCom",
            dependencies: ["Serializable"]),
        .testTarget(
            name: "BlueComTests",
            dependencies: ["BlueCom"])
    ]
)
