//
//  HomeViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 24/3/26.
//

import Foundation

extension HomeView {
    protocol ViewModel {
        var showingAddExpenseSheet: Bool { get set }
        
        func addExpenseButtonTapped()
        func prepareTodayExpensesModel(expenses: [ExpenseDBModel]) -> HomeViewExpensesTodayCell.Model
        func prepareAddExpenseViewModel() -> AddExpenseView.ViewModel
    }
    
    @Observable
    class ViewModelImpl: ViewModel {
        var showingAddExpenseSheet: Bool = false
        
        private let repository: ExpensesRepositoryProtocol
        
        init(repository: ExpensesRepositoryProtocol) {
            self.repository = repository
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
        
        func prepareAddExpenseViewModel() -> AddExpenseView.ViewModel {
            SharedContainer.resolve(AddExpenseView.ViewModel.self) ?? AddExpenseView.BaseViewModelImpl()
        }
    }
    
    // MARK: - Mock ViewModel
    class MockViewModel: ViewModel {
        var showingAddExpenseSheet: Bool = true
        func addExpenseButtonTapped() { }
        func prepareTodayExpensesModel(expenses: [ExpenseDBModel]) -> HomeViewExpensesTodayCell.Model {
            .init(
                amount: 1000.56,
                currency: "mock",
                timeStr: "mock"
            )
        }
        func prepareAddExpenseViewModel() -> AddExpenseView.ViewModel {
            return AddExpenseView.BaseViewModelImpl()
        }
    }
}
