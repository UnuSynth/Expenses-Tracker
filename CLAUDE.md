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

`Core/Foundation/` contains:
- `Calendar+Extension.swift` — `CalendarRange` struct for date range queries
- `Date+Extension.swift` — `matches(_:by:)` extension for comparing dates by a `Calendar.Component`
  - Usage: `date1.matches(date2, by: .day)` → true if same day
  - Supports: `.hour`, `.day`, `.weekOfYear`, `.month`
  - Used by TransactionsHistory for chart bar highlighting across time periods

Always prefer these utilities over manual date arithmetic.

## ViewModel Pattern

Every ViewModel file contains three things in order:

```swift
protocol ViewModel: AnyObject {
    var property: Type { get set }
    func methodName()
    @MainActor func asyncMethod()
}

@Observable
final class ViewModelImpl: ViewModel {
    @ObservationIgnored
    private let dependency: DependencyProtocol
    // implementation
}

class MockViewModel: ViewModel {
    // mock data for previews/testing
}
```

Key rules:
- Views use `@State var viewModel: any ViewModel` (protocol type, not concrete)
- Shared computed properties go in a **protocol extension at file scope** (not inside the type) to avoid duplication between `ViewModelImpl` and `MockViewModel`
- Only data-source methods differ between `ViewModelImpl` and `MockViewModel`
- Async methods touching main-thread state must be `@MainActor`
- Styling logic that depends on state belongs in ViewModel (e.g., `barColor(for:)`), not the View

## Code organization

- Views: layout and presentation only — no conditional logic or data transformation
- ViewModels: all business logic, filtering, calculations, state management
- `Core/Foundation/` extensions: reusable utilities shared across the app
- When multiple switch cases return the same value, combine: `case .a, .b:` not separate blocks
- When editing models or SwiftData schemas, keep `toEntity()`, `ExpenseDBModel(from:)`, and all layers (ViewModel → Repo → DBManager → DAO) in sync

## Feature: TransactionsHistory

**Location**: `ExpensesTrackerPackage/Sources/UI/TransactionsHistory/`

Displays expenses across time periods (D/W/M/6M/Y) with an interactive bar chart.

### Key types
- `TimePeriod` enum — D, W, M, 6M, Y with `calendarComponent` property
- `ChartDataPoint` struct — bucketed data (date, total amount) for chart bars
- `barColor(for:)` on ViewModel — uses `Date.matches(_:by:)` with the period's component to highlight the selected bar

### Chart bar selection flow
1. User taps bar → `viewModel.selectedBarDate` is set
2. `barColor(for:)` compares each bar's date with `selectedBarDate` using the period's `calendarComponent`
3. This ensures M period compares year+month only (day ignored), etc.

### Adding a new time period
1. Add case to `TimePeriod` with its `calendarComponent`
2. Ensure `bucketDate(for:component:)` handles the component
3. Add case to `Date.matches(_:by:)` if custom comparison needed
4. Update UI period selector buttons
