---
applyTo: '**/*.swift'
excludeAgent: "code-review"
---

## Feature: TransactionsHistory

**Location**: `ExpensesTrackerPackage/Sources/UI/TransactionsHistory/`

Shows expenses across time periods (D/W/M/6M/Y) with interactive bar chart.

### Key types
- `TimePeriod` enum — D, W, M, 6M, Y with `calendarComponent` property
- `ChartDataPoint` struct — bucketed data (date, total amount) for chart bars
- `barColor(for:)` on ViewModel — uses `Date.matches(_:by:)` with period's component to highlight selected bar

### Chart bar selection flow
1. User taps bar → `viewModel.selectedBarDate` set
2. `barColor(for:)` compares each bar's date with `selectedBarDate` using period's `calendarComponent`
3. M period compares year+month only (day ignored), etc.

### Adding new time period
1. Add case to `TimePeriod` with its `calendarComponent`
2. Ensure `bucketDate(for:component:)` handles component
3. Add case to `Date.matches(_:by:)` if custom comparison needed
4. Update UI period selector buttons
