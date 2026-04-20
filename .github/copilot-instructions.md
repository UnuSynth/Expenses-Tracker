# Copilot instructions for Expenses Tracker

This file helps future Copilot sessions and other AI assistants work effectively in this repository.

## Build, test, and lint commands
- Build (Xcode): Open `ExpensesTracker.xcodeproj` in Xcode.
- Build (CLI): `xcodebuild -scheme ExpensesTracker -sdk iphonesimulator`
- Run full test suite (CLI):
  xcodebuild test -scheme ExpensesTracker -destination 'platform=iOS Simulator,name=iPhone 16'
- Run a single test (example):
  xcodebuild test -scheme ExpensesTracker -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ExpensesTrackerTests/MyTestClass/testExample
  (replace `ExpensesTrackerTests/MyTestClass/testExample` with the actual test bundle/class/method name)
- Lint: No repository-wide linter configured. If adding one, update this file with exact commands.

## High-level architecture (big picture)
- Layered, MVVM-style with a clear data flow:
  View (SwiftUI) → ViewModel → Repository → DBManager → SwiftDataDAO → SwiftData
- Two main code locations:
  - App/ — app target (entry point, @main, scene setup)
  - ExpensesTrackerPackage/Sources/ — business logic and UI packaged as a local Swift Package
- Key layers in the package:
  - UI/ — SwiftUI views + ViewModels (MVVM)
  - Repository/ — `ExpensesRepositoryProtocol` and repository interfaces
  - Services/Managers/ — `ExpensesDBManager` (domain↔DB mapping)
  - Services/Storage/ — `SwiftDataDAO<T>` generic wrapper around SwiftData
  - DI/ — Swinject assemblies (`UIAssembly`, `ServicesAssembly`, `RepositoriesAssembly`)
  - Model/Entities & Model/Storage — `ExpenseModel` vs `ExpenseDBModel` (@Model)
  - Core/ — date/calendar/string helpers and DI helpers

Environment specifics:
- Minimum deployment target: iOS 26.1
- Swift version: Swift 6.2 (strict concurrency)
- Dependencies managed by Swift Package Manager (Swinject, SwinjectAutoregistration)

## Key repository conventions (important, not obvious from a single file)
- Dependency Injection: Swinject is configured at launch in `SwinjectSharedInstance`. Resolve ViewModels and repositories from this container.
- ViewModels are injected as protocol types; views accept protocol-typed ViewModels to make previews and testing easy.
- Models: keep domain (`ExpenseModel`) separate from persistence (`ExpenseDBModel`). Use `toEntity()` and `ExpenseDBModel(from:)` for conversions — update both when adding/changing fields.
- Persistence: code uses SwiftData with `@Query` in views for live updates. All write flows go through ViewModel → Repository → DBManager → SwiftDataDAO.
- Concurrency: Core persistence and DAO types are `@MainActor` — preserve actor annotations when modifying related code.
- Date utilities: `Core/Foundation/` contains `CalendarRange`, formatting helpers, and `Date.matches(_:by:)` extension used in filters and date comparisons; prefer using them for date-range features.
- Tests: Use the `xcodebuild -only-testing` pattern to run individual tests from CI or locally.
- ViewModel logic separation: ViewModels contain business logic (data transformations, filtering, state management). Views delegate to ViewModels for data-driven styling (e.g., `barColor(for:)` method).

## Date handling and calendar utilities
- `Date+Extension.swift`: Contains `matches(_:by:)` extension method for comparing dates by a specific `Calendar.Component`
  - Usage: `date1.matches(date2, by: .day)` returns true if dates are on the same day
  - Supports: `.hour`, `.day`, `.weekOfYear`, `.month` (extensible for other components)
  - Used by TransactionsHistory for chart bar highlighting across different time periods
- `Calendar+Extension.swift`: Contains `CalendarRange` struct for date range queries
- Always import `Foundation` for date operations; `SwiftUI` for `Color` types used in styling methods

## AI / assistant integration notes
- Refer to CLAUDE.md for more detailed environment and architecture notes — it contains the authoritative build/test instructions and architecture diagram used by the team.
- When editing models or SwiftData schemas, ensure conversion functions and all layers (ViewModel → Repo → DBManager → DAO) stay in sync.

## Where to look first
- For UI and view-related changes: ExpensesTrackerPackage/Sources/UI/
- For data/persistence logic: ExpensesTrackerPackage/Sources/Services/Storage and Services/Managers
- For DI patterns and registrations: ExpensesTrackerPackage/Sources/DI/

## Feature: TransactionsHistory and Charts
**Location**: `ExpensesTrackerPackage/Sources/UI/TransactionsHistory/`

### Overview
TransactionsHistory displays expenses across different time periods (D=Day, W=Week, M=Month, 6M=6 Months, Y=Year) with an interactive bar chart. Users can tap on bars to see details for that time period.

### Key Components
- **TransactionsHistoryView**: SwiftUI view with chart visualization and transaction list
- **TransactionsHistoryViewModel.swift**: 
  - Protocol `ViewModel` defines the contract (properties + methods)
  - `ViewModelImpl`: Main implementation with @Observable
  - `MockViewModel`: Preview/testing implementation
- **TimePeriod enum**: Defines time periods (D, W, M, 6M, Y) with `calendarComponent` property
- **ChartDataPoint struct**: Represents bucketed data (date, total amount) for chart bars

### Chart Bar Selection Logic
- **Issue fixed**: Chart bar selection now correctly highlights a single bar per time period instead of selecting multiple bars for D period or wrong bars for M/6M/Y periods
- **Solution**: 
  1. Created `Date+Extension.swift` with `matches(_:by:)` method that compares dates based on `Calendar.Component`
  2. Added `barColor(for:)` method to ViewModel that uses `Date.matches(_:by:)` with the selected period's component
  3. View delegates to ViewModel's `barColor(for:)` for styling bars
- **How it works**:
  - When selecting a bar, the selected date is stored in `viewModel.selectedBarDate`
  - ViewModel's `barColor(for:)` compares the bar's date with selected date using the appropriate calendar component
  - Example: For `.month` period, dates are compared by year+month only (day is ignored)

### Adding new time periods
To add a new time period:
1. Add case to `TimePeriod` enum with its `calendarComponent`
2. Ensure `bucketDate(for:component:)` handles the component correctly
3. Add case to `Date.matches(_:by:)` switch if custom comparison logic needed
4. Update UI period selector buttons if needed

### Data flow in TransactionsHistory
1. View initializes ViewModel and calls `loadExpenses()` on appear
2. ViewModel fetches expenses from Repository
3. Data is grouped and bucketed into `chartData` array by selected period
4. Chart renders bars using `barColor(for:)` method for styling
5. User tap on bar sets `selectedBarDate`, which triggers bar re-highlighting and annotation display
6. Transaction list is grouped by calendar day below the chart

### Common modifications
- **Change bar colors**: Update `Color.orange` in `ViewModelImpl.barColor(for:)` method
- **Add time period**: Follow steps in "Adding new time periods" section above
- **Fix date comparison bugs**: Always ensure changes to `Date.matches(_:by:)` handle all calendar components consistently
- **Update chart layout**: Modify chart properties in `expenseChart` property of TransactionsHistoryView

---

If you'd like changes to the wording, coverage for other areas (CI, code signing, workspace details), or to add project-specific lint/test commands, say which area to expand and Copilot will update this file.

## ViewModel Protocol Pattern
All ViewModels follow this pattern:
```swift
protocol ViewModel: AnyObject {
    // State properties
    var property: Type { get set }
    var readOnlyProperty: Type { get }
    
    // Methods
    func methodName()
    
    @MainActor
    func asyncMethod()
}

@Observable
final class ViewModelImpl: ViewModel {
    @ObservationIgnored
    private let dependency: DependencyProtocol
    
    // Implementations
}

class MockViewModel: ViewModel {
    // Mock implementations for previews/testing
}
```
- Always include both `ViewModelImpl` and `MockViewModel` implementations
- Use `@Observable` macro for reactive updates
- Mark async methods with `@MainActor` when touching main thread state
- Views use protocol type: `@State var viewModel: ViewModel` for flexibility in testing
- **DRY principle**: Move shared computed properties and methods to a protocol extension at file scope (not inside the type). Example:
  ```swift
  extension TransactionsHistoryView.ViewModel {
      var sharedProperty: Type { /* shared implementation */ }
      func sharedMethod() { /* shared implementation */ }
  }
  ```
  This prevents code duplication between `ViewModelImpl` and `MockViewModel`. Only implement data source methods (like `chartData` in ViewModelImpl vs mock data in MockViewModel) in each class separately.

## View-ViewModel Communication Patterns
- **State binding**: Views use `@State var viewModel: ViewModel` for protocol-typed injection
- **Method delegation**: Views call ViewModel methods for business logic (e.g., `barColor(for:)`, `loadExpenses()`)
- **Data transformation**: ViewModel handles all data transformation; Views are purely presentational
- **Preview support**: Use `MockViewModel()` in preview blocks for instant previews without network/DB access

## Code organization tips
- Keep Views focused on layout and presentation only
- Move any conditional logic, calculations, or data transformations to ViewModel
- Use ViewModel helper methods (even private ones) to keep views clean
- For styling logic that depends on state, implement in ViewModel (not View)
- Extension methods in `Core/Foundation/` are reusable across the app; add utility there
- **Switch statement optimization**: When multiple cases return the same value, combine them using comma-separated syntax: `case .a, .b:` instead of repeating the same code in separate cases
