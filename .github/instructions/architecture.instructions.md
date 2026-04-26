---
applyTo: '**/*.swift'
excludeAgent: "code-review"
---

## Architecture

```
View (SwiftUI) → ViewModel → Repository → DBManager → SwiftDataDAO → SwiftData
```

| Layer | Path | Role |
|---|---|---|
| UI | `UI/` | SwiftUI views + ViewModels (MVVM) |
| Repository | `Repository/` | `ExpensesRepositoryProtocol` |
| Services | `Services/Managers/` | `ExpensesDBManager` — transforms domain↔DB models |
| Storage | `Services/Storage/` | `SwiftDataDAO<T>` |
| DI | `DI/` | `UIAssembly`, `ServicesAssembly`, `RepositoriesAssembly` |
| Model | `Model/Entities/` + `Model/Storage/` | domain vs SwiftData models |
| Core | `Core/` | Date/Calendar/String extensions + Swinject helpers |

Code in two places:
- `Expenses Tracker/` — app target (`@main`, scene setup)
- `ExpensesTrackerPackage/Sources/` — all business logic + UI

**DI**: Swinject configured at launch in `SwinjectSharedInstance`. Views accept protocol-typed ViewModels — enables mock injection for Previews.

**Data flow**: `@Query` for live reads. Write ops: ViewModel → Repository → DBManager → SwiftDataDAO. All `@MainActor`.
