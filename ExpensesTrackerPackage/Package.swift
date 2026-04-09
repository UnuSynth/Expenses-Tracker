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
        .package(url: "https://github.com/swinject/swinject", from: "2.10.0")
    ],
    targets: [
        .target(
            name: "ExpensesTrackerPackage",
            
            dependencies: [
                .product(
                    name: "Swinject",
                    package: "swinject"
                )
            ]
        ),
    ]
)
