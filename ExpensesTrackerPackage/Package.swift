// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExpensesTrackerPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "ExpensesTrackerPackage",
            targets: ["ExpensesTrackerPackage"]
        ),
    ],
    targets: [
        .target(
            name: "ExpensesTrackerPackage",
            resources: [],
            swiftSettings: [
                .enableUpcomingFeature("StringCatalogSymbols")
            ]
        ),
    ]
)
