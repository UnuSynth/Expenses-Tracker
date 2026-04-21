//
//  AddExpenseViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

extension AddExpenseView {
    @MainActor
    protocol ViewModel: AnyObject, Observable {
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
    
    // BaseViewModelImpl is used to mock real view model functionality
    @Observable
    @MainActor
    class BaseViewModelImpl: ViewModel {
        var date: Date = .now
        var amountString: String = ""
        fileprivate var amountDouble: Double? {
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
        
        func saveExpense() { }
    }
    
    @Observable
    @MainActor
    final class ViewModelImpl: BaseViewModelImpl {
        private let repository: ExpensesRepositoryProtocol
        
        init(repository: ExpensesRepositoryProtocol) {
            self.repository = repository
        }
        
        override func saveExpense() {
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
