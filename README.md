# ExpensesTrackerAI

Simple native iOS personal finance app. We are launching to App Store soon!

## Requirements

- Xcode 16+
- iOS 18+ (device or simulator)

## Project layout

`ExpensesTracker.xcodeproj` (scheme `ExpensesTracker`) is a thin app shell — `App/ExpensesTrackerApp.swift` sets up the SwiftData `modelContainer`, seeds it, and hosts `ExpensesTrackerViewer` from the local Swift package. All real code lives in the local SPM package `ExpensesTrackerPackage/` (iOS 18+, Swift tools 6.2):

- `Sources/Model` — SwiftData `@Model` types, versioned schemas/migrations, DB seeders, value types like `Money`/`Currency`.
- `Sources/UI` — screens and components, grouped by feature (`Home`, `Settings`, `ExpenseEditor`, `PartnerLink`, `MainViewer`).
- `Sources/Core` — cross-cutting utilities (typed `UserDefaults` keys, `Foundation`/`SwiftUI` extensions).
- `Sources/Localizable` — `Localizable.xcstrings` string catalog.

## Build & run

Open `ExpensesTracker.xcodeproj` in Xcode, select the `ExpensesTracker` scheme, and run on an iOS 18+ simulator or device.

CLI build:

```bash
xcodebuild -project ExpensesTracker.xcodeproj -scheme ExpensesTracker \
  -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Using [SweetPad](https://marketplace.visualstudio.com/items?itemName=sweetpad.sweetpad) in VS Code: run `xcode-build-server config -project ExpensesTracker.xcodeproj -scheme ExpensesTracker` once to regenerate the (gitignored) `buildServer.json`, then use the launch configuration in `.vscode/launch.json`.

## Architecture

Each screen has a `@MainActor` protocol ViewModel plus an `@Observable` implementation (`FooViewModel.swift` / `FooViewModel+Impl.swift`). Views only render and forward actions; all state/filtering/calculation lives in the ViewModel. Persistence is SwiftData, with versioned schemas under `Storage/Migration` for model changes. See `CLAUDE.md` for full architecture notes.

## License

Proprietary — see [LICENSE](LICENSE). All rights reserved.
