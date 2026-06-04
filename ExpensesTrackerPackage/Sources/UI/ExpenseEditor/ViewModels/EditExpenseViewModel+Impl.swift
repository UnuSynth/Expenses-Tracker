//
//  EditExpenseViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 2/6/26.
//

import Foundation

@Observable
@MainActor
final class EditExpenseViewModel: ExpenseEditorViewModel {
    private let repository: ExpensesRepositoryProtocol
    
    private var expenseDBModel: ExpenseDBModel
    var date: Date
    var amountString: String
    var category: ExpenseModel.Category
    var notes: String
    
    init(
        repository: ExpensesRepositoryProtocol,
        expenseDBModel: ExpenseDBModel
    ) {
        self.repository = repository
        self.expenseDBModel = expenseDBModel
        
        date = expenseDBModel.date
        amountString = expenseDBModel.amount.description
        category = expenseDBModel.category
        notes = expenseDBModel.notes?.desc ?? ""
    }
    
    func saveExpense() {
        guard expenseDBModel.date != date
                || expenseDBModel.amount != (amountDouble ?? 0)
                || expenseDBModel.category != category
                || notes != expenseDBModel.notes?.desc
        else { return }
        
        let newExpense: ExpenseModel = .init(
            date: date,
            amount: amountDouble ?? 0,
            category: category,
            notes: notes.isEmpty ? nil : .init(desc: notes)
        )
        
        repository.edit(
            expenseID: expenseDBModel.id,
            newValue: newExpense
        )
    }
    
    func deleteExpense() {
        repository.delete(expenseID: expenseDBModel.id)
    }
}
