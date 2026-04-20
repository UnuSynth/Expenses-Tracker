# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

This is a standard Xcode project — no custom build scripts.

- **Build**: Open `ExpensesTracker.xcodeproj` in Xcode or run `xcodebuild -scheme ExpensesTracker -sdk iphonesimulator`
- **Run tests**: `xcodebuild test -scheme ExpensesTracker -destination 'platform=iOS Simulator,name=iPhone 16'`
- **Minimum deployment target**: iOS 26.1
- **Swift**: 6.2 (strict concurrency)
- **Dependencies**: Managed via Swift Package Manager (Swinject, SwinjectAutoregistration)

## Architecture

The app uses a clean layered architecture:

```
View (SwiftUI) → ViewModel → Repository → DBManager → SwiftDataDAO → SwiftData
```

Code lives in two places:
- `Expenses Tracker/` — app target (entry point, `@main`, scene setup)
- `ExpensesTrackerPackage/Sources/` — all business logic and UI as a local Swift package

### Package layers

| Layer | Path | Role |
|---|---|---|
| UI | `UI/` | SwiftUI views + ViewModels (MVVM) |
| Repository | `Repository/` | Data access protocol (`ExpensesRepositoryProtocol`) |
| Services | `Services/Managers/` | `ExpensesDBManager` — transforms domain↔DB models |
| Storage | `Services/Storage/` | Generic `SwiftDataDAO<T>` wrapping SwiftData |
| DI | `DI/` | Swinject assemblies: `UIAssembly`, `ServicesAssembly`, `RepositoriesAssembly` |
| Model | `Model/Entities/` + `Model/Storage/` | `ExpenseModel` (domain) vs `ExpenseDBModel` (SwiftData) |
| Core | `Core/` | Date/Calendar/String extensions + Swinject helpers |

### Dependency injection

Swinject is configured at app launch in `SwinjectSharedInstance`. All ViewModels and repositories are resolved through this container. Every view accepts a protocol-typed ViewModel so a mock can be injected for SwiftUI Previews.

### Data flow

Views use `@Query` for live SwiftData updates. Write operations go through the ViewModel → Repository → DBManager → SwiftDataDAO chain. All these types are `@MainActor`.

### Models

Two separate model types exist intentionally:
- `ExpenseModel` — in-memory domain model used by all business logic
- `ExpenseDBModel` — `@Model`-annotated SwiftData persistence model

Convert between them with `toEntity()` (DB→domain) and `ExpenseDBModel(from:)` (domain→DB).

### Date utilities

`Core/Foundation/` contains `CalendarRange` enum (day/week/month/6mo/year/custom) and date formatting helpers used throughout the app for filtering and display.
