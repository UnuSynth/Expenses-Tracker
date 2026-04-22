//
//  AddExpenseViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

@MainActor
protocol AddExpenseViewModel: AnyObject, Observable {
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

extension AddExpenseViewModel {
    fileprivate var amountDouble: Double? {
        amountString.toDouble()
    }
    
    var isValid: Bool {
        amountString.isEmpty == false
        && amountDouble != nil
    }
    
    var datesRange: ClosedRange<Date> {
        // a date range between 20 years ago and now
        Date.now.addingTimeInterval(-1*3600*24*365*20)...Date.now
    }
    
    var categories: [ExpenseModel.Category] {
        ExpenseModel.Category.allCases
    }
}

@Observable
@MainActor
final class AddExpenseViewModelImpl: AddExpenseViewModel {
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

// BaseViewModelImpl is used to mock real view model functionality
@Observable
@MainActor
class AddExpenseMockViewModel: AddExpenseViewModel {
    var date: Date = .now
    var amountString: String = ""
    var category: ExpenseModel.Category = .groceries
    var notes: String = ""
    func saveExpense() { }
}
