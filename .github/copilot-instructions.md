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
- Date utilities: `Core/Foundation/` contains `CalendarRange` and formatting helpers used in filters; prefer using them for date-range features.
- Tests: Use the `xcodebuild -only-testing` pattern to run individual tests from CI or locally.

## AI / assistant integration notes
- Refer to CLAUDE.md for more detailed environment and architecture notes — it contains the authoritative build/test instructions and architecture diagram used by the team.
- When editing models or SwiftData schemas, ensure conversion functions and all layers (ViewModel → Repo → DBManager → DAO) stay in sync.

## Where to look first
- For UI and view-related changes: ExpensesTrackerPackage/Sources/UI/
- For data/persistence logic: ExpensesTrackerPackage/Sources/Services/Storage and Services/Managers
- For DI patterns and registrations: ExpensesTrackerPackage/Sources/DI/


---

If you'd like changes to the wording, coverage for other areas (CI, code signing, workspace details), or to add project-specific lint/test commands, say which area to expand and Copilot will update this file.
