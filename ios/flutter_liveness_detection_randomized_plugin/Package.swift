// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_liveness_detection_randomized_plugin",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(
            name: "flutter-liveness-detection-randomized-plugin",
            targets: ["flutter_liveness_detection_randomized_plugin"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "flutter_liveness_detection_randomized_plugin",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
