// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwitGrap",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwitGrap",
            targets: ["SwitGrap"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/swit-graph/SwitGrapPluginSupport", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
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
