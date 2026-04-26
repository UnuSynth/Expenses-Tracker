---
applyTo: '**/*.swift'
excludeAgent: "code-review"
---

## ViewModel Conventions

Every ViewModel file — three things in order:

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

Rules:
- Views use `@State var viewModel: any ViewModel` (protocol type, not concrete)
- Shared computed properties → **protocol extension at file scope**, not inside type
- Only data-source methods differ between `ViewModelImpl` and `MockViewModel`
- Async methods touching main-thread state → `@MainActor`
- Styling logic depending on state → ViewModel (e.g. `barColor(for:)`), not View

