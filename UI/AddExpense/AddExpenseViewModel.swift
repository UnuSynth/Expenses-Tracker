//
//  AddExpenseViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

extension AddExpenseView {
    protocol ViewModel {
        var date: Date { get set }
        var amount: String { get set }
        var category: ExpenseModel.Category { get set }
        var notes: String { get set }
        
        func getCategories() -> [ExpenseModel.Category]
        func saveExpense()
    }
    
    @Observable
    final class ViewModelImplementation: ViewModel {
        var date: Date = .now
        var amount: String = ""
        var category: ExpenseModel.Category = .groceries
        var notes: String = ""
        
        func getCategories() -> [ExpenseModel.Category] {
            return ExpenseModel.Category.allCases
        }
        
        func saveExpense() {
            let expense = ExpenseModel(
                date: date,
                amount: Double(amount) ?? 0,
                category: category,
                notes: .init(description: notes)
            )
            
            debugPrint(expense.amount)
            debugPrint(expense.category)
            debugPrint(expense.date)
            debugPrint(expense.notes as Any)
        }
    }
}

