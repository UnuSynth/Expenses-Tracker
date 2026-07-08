# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What Is This

ExpensesTrackerAI: simple native iOS personal finance app for couples. Inspired by Apple Health app. Tracking should feel natural, insightful — Simple, Smart, Clear, unmistakably Apple.

## Project layout

The Xcode project (`ExpensesTracker.xcodeproj`, scheme `ExpensesTracker`) is a thin app shell — `App/ExpensesTrackerApp.swift` just sets up the SwiftData `modelContainer` and seeds it, then hosts `ExpensesTrackerViewer` from the local Swift package. All real code lives in the local SPM package `ExpensesTrackerPackage/` (iOS 18+, Swift tools 6.2), organized as:

- `Sources/Model` — SwiftData `@Model` types (`ExpenseDBModel`, `CategoryModel`), versioned schemas/migrations (`Storage/Migration`), DB seeders (`Storage/Seeders`), and value types like `Money`/`Currency`.
- `Sources/UI` — screens and components, grouped by feature (`Home`, `Settings`, `ExpenseEditor`, `PartnerLink`, `MainViewer`).
- `Sources/Core` — cross-cutting utilities: `AppStorageKeys` (typed `UserDefaults` keys), `Foundation`/`SwiftUI` extensions.
- `Sources/Localizable` — `Localizable.xcstrings` string catalog.

There is no test target in this repo currently.

## Commands

Build/run is normally driven through Xcode or the SweetPad VS Code extension (see `.vscode/launch.json`), not raw `xcodebuild`, since this is an iOS app requiring a simulator. If you need CLI:

```bash
xcodebuild -project ExpensesTracker.xcodeproj -scheme ExpensesTracker \
  -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Swift package alone (SwiftUI-only code will fail to type-check outside an iOS destination target since it depends on iOS 18 APIs):

```bash
cd ExpensesTrackerPackage && swift build
```

## Architecture notes

- **ViewModel pattern**: each screen defines a `@MainActor protocol` ViewModel (e.g. `HomeViewModel.swift`) plus an `@Observable` implementation in a separate `+Impl.swift` file (e.g. `HomeViewModel+Impl.swift`). Views take the protocol type via init injection, not the concrete class — keep this split when adding new screens.
- **Views vs ViewModels**: Views only render and forward user actions; all filtering/calculation/state lives in the ViewModel `Impl`. E.g. `HomeViewModelImpl` recomputes derived state (`groupedExpenses`, `spendingHeroModel`) via private `recompute*()` methods triggered by `didSet` on inputs like `selectedPeriod`, `searchText`, `selectedCategoryFilter` — follow this reactive-recompute style rather than computing in the View body.
- **SwiftData migrations**: schemas are versioned in `Storage/Migration` (`ExpensesTrackerSchemaV1`, etc. conforming to `VersionedSchema`) — add a new versioned schema + migration stage there when changing `@Model` types, don't edit existing model schemas in place.
- **Localization**: user-facing strings go through `Localizable.xcstrings` and are referenced as `LocalizedStringResource` static members (e.g. `.expensesTrackerAi`), not raw string literals. `String(resource:locale:)` in `Core/Foundation/String+Extensions.swift` is the helper for locale-aware resolution (the app supports runtime language switching via `AppStorageKeys.languageCode`).
- **Currency/money**: currency codes and formatting go through `Currency`/`Money` (`Model/Entities/Money`) and `String.currencySymbol(for:)` — don't hardcode currency symbols elsewhere.
