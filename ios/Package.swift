// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_liveness_detection_randomized_plugin",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "flutter-liveness-detection-randomized-plugin", targets: ["flutter_liveness_detection_randomized_plugin"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "flutter_liveness_detection_randomized_plugin",
            dependencies: [],
            path: "Classes",
            resources: [
                .process("../Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
