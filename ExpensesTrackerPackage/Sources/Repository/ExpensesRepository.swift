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
    func fetchAll() throws -> [ExpenseModel]
    
    @MainActor
    func delete(expenseID: UUID)
}

final class ExpensesRepository: ExpensesRepositoryProtocol {
    private let expensesDBManager: ExpensesDBManagerProtocol
    
    init(expensesDBManager: ExpensesDBManagerProtocol) {
        self.expensesDBManager = expensesDBManager
    }
    
    func save(expense: ExpenseModel) {
        expensesDBManager.saveExpense(expense)
    }
    
    func fetchAll() throws -> [ExpenseModel] {
        try expensesDBManager.fetchAllExpenses()
    }
    
    func delete(expenseID: UUID) {
        expensesDBManager.deleteExpense(withID: expenseID)
    }
}

final class ExpensesRepositoryMock: ExpensesRepositoryProtocol {
    func save(expense: ExpenseModel) { }
    func fetchAll() throws -> [ExpenseModel] { [] }
    func delete(expenseID: UUID) { }
}
