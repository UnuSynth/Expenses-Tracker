//
//  HomeViewModel+Impl.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import Foundation

@Observable
@MainActor
class HomeViewModelImpl: HomeViewModel {
    var selectedPeriod: Calendar.Period = .day
    var spendingHeroModel: HeroDashboardModel = .init(chips: [])
    var showSettingsSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    var showingEditExpenseSheet: Bool = false
    @ObservationIgnored var searchText: String = "" {
        didSet { recomputeGroupedExpenses() }
    }
    @ObservationIgnored var selectedCategoryFilter: CategoryModel? {
        didSet { recomputeGroupedExpenses() }
    }

    @ObservationIgnored private var rawExpenses: [ExpenseDBModel] = []
    private(set) var groupedExpenses: [(date: Date, items: [ExpenseDBModel], total: Double)] = []
    
    @ObservationIgnored var toEditExpense: ExpenseDBModel? = nil

    func updateExpenses(_ expenses: [ExpenseDBModel]) {
        rawExpenses = expenses
        recomputeSpendingHero()
        recomputeGroupedExpenses()
    }

    func editExpenese(_ expense: ExpenseDBModel) {
        toEditExpense = expense
        showingEditExpenseSheet = true
    }
}

private extension HomeViewModelImpl {
    func recomputeSpendingHero() {
        let totalsByCategory = rawExpenses.reduce(into: [CategoryModel: Double]()) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }

        let chips = totalsByCategory
            .sorted { $0.value > $1.value }
            .map { HeroDashboardModel.ChipModel(amount: $0.value, category: $0.key) }

        spendingHeroModel = .init(chips: chips)
    }

    func recomputeGroupedExpenses() {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces).lowercased()

        let filtered = rawExpenses.filter { expense in
            if let category = selectedCategoryFilter, expense.category != category { return false }
            if !trimmedSearch.isEmpty {
                return expense.notes?.desc?.lowercased().contains(trimmedSearch) ?? false
                || expense.category.name.lowercased().contains(trimmedSearch)
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
