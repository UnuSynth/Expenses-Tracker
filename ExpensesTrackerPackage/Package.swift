// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExpensesTrackerPackage",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "ExpensesTrackerPackage",
            targets: ["ExpensesTrackerPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swinject/Swinject.git", from: "2.10.0"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", from: "2.9.1"),
    ],
    targets: [
        .target(
            name: "ExpensesTrackerPackage",
            dependencies: [
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "SwinjectAutoregistration", package: "SwinjectAutoregistration"),
            ]
        ),
    ]
)
