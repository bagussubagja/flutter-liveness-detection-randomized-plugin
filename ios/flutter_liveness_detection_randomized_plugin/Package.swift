// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_liveness_detection_randomized_plugin",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        .library(name: "flutter-liveness-detection-randomized-plugin", targets: ["flutter_liveness_detection_randomized_plugin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_liveness_detection_randomized_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
