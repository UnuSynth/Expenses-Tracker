//
//  HomeViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 24/3/26.
//

import Foundation

@MainActor
protocol HomeViewModel: AnyObject, Observable {
    var showPartnerSheet: Bool { get set }
    var showingAddExpenseSheet: Bool { get set }
    
    func partnerButtonTapped()
    func addExpenseButtonTapped()
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel]) -> SpendingHeroModel
    func prepareAddExpenseViewModel() -> AddExpenseViewModel
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel
}

extension HomeViewModel {
    func partnerButtonTapped() {
        showPartnerSheet = true
    }
    
    func addExpenseButtonTapped() {
        showingAddExpenseSheet = true
    }
}

@Observable
@MainActor
class HomeViewModelImpl: HomeViewModel {
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    
    private let repository: ExpensesRepositoryProtocol
    private var displayCurrency: String {
        "KGS"
    }
    
    init(repository: ExpensesRepositoryProtocol) {
        self.repository = repository
    }
    
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel]) -> SpendingHeroModel {
        return .init(
            total: thisMonthTotal(expenses: expenses),
            currency: displayCurrency,
            average: thirtyDayAverage(expenses: expenses),
            partnerTotal: nil
        )
        
        func thisMonthTotal(expenses: [ExpenseDBModel]) -> Double {
            let start = Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now
            let thisMonthExpenses = expenses.filter { $0.date >= start }
            return thisMonthExpenses.reduce(0) { $0 + $1.amount }
        }
        
        func thirtyDayAverage(expenses: [ExpenseDBModel]) -> Double {
            let cal = Calendar.current
            guard let thirtyDaysAgo = cal.date(byAdding: .day, value: -30, to: .now) else { return 0 }
            let recent = expenses.filter { $0.date >= thirtyDaysAgo }
            guard !recent.isEmpty else { return 0 }
            let days = Set(recent.map { cal.startOfDay(for: $0.date) }).count
            let total = recent.reduce(0) { $0 + $1.amount }
            return days > 0 ? (total / Double(days)) * 30 : 0
        }
    }
    
    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        SharedContainer.resolve(AddExpenseViewModel.self) ?? AddExpenseMockViewModel()
    }
    
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel {
        SharedContainer.resolve(HistoryViewModel.self) ?? HistoryViewModelImpl(repository: repository)
    }
}

// MARK: - Mock ViewModel
@Observable
@MainActor
class HomeMockViewModel: HomeViewModel {
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    private var displayCurrency: String {
        "KGS"
    }
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel]) -> SpendingHeroModel {
        .init(
            total: 1400.3,
            currency: displayCurrency,
            average: 1860.13,
            partnerTotal: nil
        )
    }
    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        return AddExpenseMockViewModel()
    }
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel {
        return HistoryMockViewModel()
    }
}
