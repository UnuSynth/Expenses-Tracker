//
//  HomeViewModel+Mock.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import Foundation

// MARK: - Mock ViewModel
@Observable
@MainActor
class HomeMockViewModel: HomeViewModel {
    var spendingHeroModel: HeroDashboardModel = .init(chips: [])
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    private var displayCurrency: String {
        "KGS"
    }

    private let mockExpenses: [ExpenseDBModel] = {
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
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel]) {
        let totalsByCategory = mockExpenses.reduce(into: [ExpenseModel.Category: Double]()) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }

        let chips: [HeroDashboardModel.ChipModel] = ExpenseModel.Category.allCases.compactMap { category -> HeroDashboardModel.ChipModel? in
            guard let amount = totalsByCategory[category] else {
                return nil
            }

            return HeroDashboardModel.ChipModel(
                amount: amount,
                category: category
            )
        }

        spendingHeroModel = .init(chips: chips)
    }
    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        return AddExpenseMockViewModel()
    }
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel {
        return HistoryMockViewModel()
    }
}
