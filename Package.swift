// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwitGrap",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "SwitGrap", targets: ["SwitGrap"]),
        .library(name: "SwitGrapModuleImportPlugin", type: .dynamic, targets: ["SwitGrapModuleImportPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/swit-graph/SwitGrapPluginSupport", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        .target(
            name: "SwitGrap",
            dependencies: [
                "SwitGrapLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "SwitGrapLib",
            dependencies: [
                "SwitGrapPluginSupport",
            ]
        ),
        .target(
            name: "SwitGrapModuleImportPlugin",
            dependencies: [
                "SwitGrapPluginSupport",
            ]
        ),
        
        .testTarget(
            name: "SwitGrapTests",
            dependencies: ["SwitGrap"]),
        
        .testTarget(name: "SwitGrapLibTests",
                   dependencies: ["SwitGrapLib"])
    ]
)
