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
        var amountString: String { get set }
        var category: ExpenseModel.Category { get set }
        var notes: String { get set }
        var isValid: Bool { get }
        var datesRange: ClosedRange<Date> { get }
        var categories: [ExpenseModel.Category] { get }
        
        @MainActor
        func saveExpense()
    }
    
    @Observable
    final class ViewModelImpl: ViewModel {
        var date: Date = .now
        var amountString: String = ""
        private var amountDouble: Double? {
            amountString.toDouble()
        }
        var category: ExpenseModel.Category = .groceries
        var notes: String = ""
        
        var isValid: Bool {
            amountString.isEmpty == false
            && amountDouble != nil
        }
        
        var datesRange: ClosedRange<Date> {
            Date.now.addingTimeInterval(-1*3600*24*365*20)...Date.now
            // a date range between 20 years ago and now
        }
        
        var categories: [ExpenseModel.Category] {
            ExpenseModel.Category.allCases
        }
        
        private let repository: ExpensesRepositoryProtocol
        
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
}

