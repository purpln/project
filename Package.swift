// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Project", products: [
    .library(name: "Project", targets: ["Project"]),
], dependencies: [
    .package(url: "https://github.com/purpln/tinyfoundation.git", branch: "main"),
], targets: [
    .target(name: "Project", dependencies: [
        .product(name: "TinyFoundation", package: "tinyfoundation"),
    ]),
])
