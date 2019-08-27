// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

internal let package = Package(
    name: "Serializable",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Serializable",
            targets: ["Serializable"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2")
    ],
    targets: [
        .target(
            name: "Serializable",
            dependencies: []),
        .testTarget(
            name: "SerializableTests",
            dependencies: ["Serializable", "Quick", "Nimble"])
    ]
)
