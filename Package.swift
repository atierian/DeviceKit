// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeviceKit",
    products: [
        .library(
            name: "DeviceKit",
            targets: ["DeviceKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DeviceKit",
            dependencies: [],
            resources: [
                .process("Devices")
            ]
        ),
        .testTarget(
            name: "DeviceKitTests",
            dependencies: ["DeviceKit"]),
    ]
)
