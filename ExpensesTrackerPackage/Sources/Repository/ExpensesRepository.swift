//
//  ExpensesRepository.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 20/2/26.
//

import Foundation

protocol ExpensesRepositoryProtocol {
    @MainActor
    func save(expense: ExpenseModel)
    
    @MainActor
    func edit(expenseID: UUID, newValue: ExpenseModel)
    
    @MainActor
    func delete(expenseID: UUID)
    
    @MainActor
    func deleteExpense(_ expense: ExpenseDBModel)
}

final class ExpensesRepository: ExpensesRepositoryProtocol {
    private let expensesDBManager: ExpensesDBManagerProtocol
    
    init(expensesDBManager: ExpensesDBManagerProtocol) {
        self.expensesDBManager = expensesDBManager
    }
    
    func save(expense: ExpenseModel) {
        expensesDBManager.saveExpense(expense)
    }
    
    func edit(expenseID: UUID, newValue: ExpenseModel) {
        expensesDBManager.editExpense(withID: expenseID, newValue: newValue)
    }
    
    func delete(expenseID: UUID) {
        expensesDBManager.deleteExpense(withID: expenseID)
    }
    
    func deleteExpense(_ expense: ExpenseDBModel) {
        expensesDBManager.deleteExpense(expense)
    }
}

final class ExpensesRepositoryMock: ExpensesRepositoryProtocol {
    func save(expense: ExpenseModel) { }
    func fetchAll() throws -> [ExpenseModel] { [] }
    func edit(expenseID: UUID, newValue: ExpenseModel) { }
    func delete(expenseID: UUID) { }
    func deleteExpense(_ expense: ExpenseDBModel) { }
}
