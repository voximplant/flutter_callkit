// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_callkit_voximplant",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-callkit-voximplant", targets: ["flutter_callkit_voximplant"])
    ],
    targets: [
        .target(
            name: "flutter_callkit_voximplant",
            cSettings: [
                .headerSearchPath("include/flutter_callkit_voximplant")
            ]
        )
    ]
)
