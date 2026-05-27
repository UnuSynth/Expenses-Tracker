//
//  HomeViewModel+Impl.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import Foundation

@MainActor
let mockExpenses: [ExpenseDBModel] = {
    let calendar = Calendar.current
    let now = Date.now
    let categories: [ExpenseModel.Category] = [.groceries, .lunch, .clothes, .sport, .transport, .entertainment, .health, .utilities]
    let amounts: [Double] = [
        1250.43, 480.13, 3200.75, 890.20, 1560.55,
        210.41, 6750.90, 990.35, 430.60, 1880.15,
        560.05, 2340.99, 770.45, 1120.80, 3990.10,
        290.25, 1540.70, 820.30, 6100.50, 405.95,
        2780.85, 935.40, 1680.65, 520.75, 3490.22,
    ]
    let notes: [String?] = [
        "Weekly shopping", "Coffee with friends", nil, "Gym membership", "New jacket",
        nil, "Protein bars", "Bus ticket", "Team lunch", nil,
        "Running shoes", "Dinner", nil, "Snacks", "Monthly pass",
        nil, "Pharmacy", "Taxi", "Concert tickets", nil,
        "Household supplies", "Breakfast", nil, "Online order", "Yoga class",
    ]
    
    return (0..<25).compactMap { index -> ExpenseDBModel? in
        guard let date = calendar.date(byAdding: .day, value: -(index % 7), to: now) else {
            return nil
        }
        let hour = 8 + (index % 12)
        let expenseDate = calendar.date(
            bySettingHour: hour,
            minute: (index * 7) % 60,
            second: 0,
            of: date
        ) ?? date
        
        return ExpenseDBModel(
            model: ExpenseModel(
                date: expenseDate,
                amount: amounts[index],
                category: categories[index % categories.count],
                notes: notes[index % notes.count].map { .init(desc: $0) }
            )
        )
    }
}()

@Observable
@MainActor
class HomeViewModelImpl: HomeViewModel {
    var selectedPeriod: Calendar.Period = .day {
        didSet {
            recomputeFilteredByDateExpenses()
            recomputeSpendingHero()
            recomputeGroupedExpenses()
        }
    }
    var spendingHeroModel: HeroDashboardModel = .init(chips: [])
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    var searchText: String = "" {
        didSet { recomputeGroupedExpenses() }
    }
    var selectedCategoryFilter: ExpenseModel.Category? {
        didSet { recomputeGroupedExpenses() }
    }
    
    private var rawExpenses: [ExpenseDBModel] = []
    private var filteredByDateExpenses: [ExpenseDBModel] = []
    private(set) var groupedExpenses: [(date: Date, items: [ExpenseDBModel], total: Double)] = []

    private var displayCurrency: String {
        "KGS"
    }

    func updateExpenses(_ expenses: [ExpenseDBModel]) {
        rawExpenses = expenses
        recomputeFilteredByDateExpenses()
        recomputeSpendingHero()
        recomputeGroupedExpenses()
    }

    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        SharedContainer.resolve(AddExpenseViewModel.self) ?? AddExpenseMockViewModel()
    }
    
    private func recomputeFilteredByDateExpenses() {
        let range = selectedPeriod.dates
        filteredByDateExpenses = rawExpenses.filter { expense in
            return expense.date >= range.start && expense.date <= range.end
        }
    }
    
    private func recomputeSpendingHero() {
        let totalsByCategory = filteredByDateExpenses.reduce(into: [ExpenseModel.Category: Double]()) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }

        let chips = totalsByCategory
            .sorted { $0.value > $1.value }
            .map { HeroDashboardModel.ChipModel(amount: $0.value, category: $0.key) }

        spendingHeroModel = .init(chips: chips)
    }

    private func recomputeGroupedExpenses() {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces).lowercased()

        let filtered = filteredByDateExpenses.filter { expense in
            if let category = selectedCategoryFilter, expense.category != category { return false }
            if !trimmedSearch.isEmpty {
                let matchesDesc = expense.notes?.desc?.lowercased().contains(trimmedSearch) ?? false
                let matchesCategory = expense.category.displayName.lowercased().contains(trimmedSearch)
                guard matchesDesc || matchesCategory else { return false }
            }
            return true
        }

        let grouped = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        groupedExpenses = grouped
            .sorted { $0.key > $1.key }
            .map { date, items in
                let sorted = items.sorted { $0.date > $1.date }
                return (date: date, items: sorted, total: sorted.reduce(0) { $0 + $1.amount })
            }
    }
}
