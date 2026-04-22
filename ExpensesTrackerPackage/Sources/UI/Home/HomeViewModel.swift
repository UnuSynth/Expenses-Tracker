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
    func prepareTodayExpensesModel(expenses: [ExpenseDBModel]) -> HomeViewExpensesTodayCell.Model
    func prepareAddExpenseViewModel() -> AddExpenseViewModel
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel
}

@Observable
@MainActor
class HomeViewModelImpl: HomeViewModel {
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    
    private let repository: ExpensesRepositoryProtocol
    
    init(repository: ExpensesRepositoryProtocol) {
        self.repository = repository
    }
    
    func partnerButtonTapped() {
        showPartnerSheet = true
    }
    
    func addExpenseButtonTapped() {
        showingAddExpenseSheet = true
    }
    
    func prepareTodayExpensesModel(expenses: [ExpenseDBModel]) -> HomeViewExpensesTodayCell.Model {
        .init(
            amount: expenses.reduce(.zero) { $0 + $1.amount },
            currency: "mock",
            timeStr: "mock"
        )
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
    var showingAddExpenseSheet: Bool = true
    func partnerButtonTapped() { }
    func addExpenseButtonTapped() { }
    func prepareTodayExpensesModel(expenses: [ExpenseDBModel]) -> HomeViewExpensesTodayCell.Model {
        .init(
            amount: 1000.56,
            currency: "mock",
            timeStr: "mock"
        )
    }
    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        return AddExpenseMockViewModel()
    }
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel {
        return HistoryMockViewModel()
    }
}
