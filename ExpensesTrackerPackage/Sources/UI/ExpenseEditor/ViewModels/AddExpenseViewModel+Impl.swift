//
//  AddExpenseViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

@Observable
@MainActor
final class AddExpenseViewModelImpl: ExpenseEditorViewModel {
    private let repository: ExpensesRepositoryProtocol
    
    var date: Date = .now
    var amountString: String = ""
    var category: ExpenseModel.Category = .groceries
    var notes: String = ""
    
    init(repository: ExpensesRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveExpense() {
        let expense = ExpenseModel(
            date: date,
            amount: amountDouble ?? 0,
            category: category,
            notes: .init(desc: notes)
        )
        
        repository.save(expense: expense)
    }
}
