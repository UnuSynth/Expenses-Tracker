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
    func getCount(in category: ExpenseModel.Category) -> Int
    
    @MainActor
    func edit(expenseID: UUID, newValue: ExpenseModel)
    
    @MainActor
    func delete(expenseID: UUID)
}

final class ExpensesRepository: ExpensesRepositoryProtocol {
    private let expensesDBManager: ExpensesDBManagerProtocol
    
    init(expensesDBManager: ExpensesDBManagerProtocol) {
        self.expensesDBManager = expensesDBManager
    }
    
    func getCount(in category: ExpenseModel.Category) -> Int {
        expensesDBManager.getCount(in: category)
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
}

final class ExpensesRepositoryMock: ExpensesRepositoryProtocol {
    func save(expense: ExpenseModel) { }
    func getCount(in category: ExpenseModel.Category) -> Int { 0 }
    func fetchAll() throws -> [ExpenseModel] { [] }
    func edit(expenseID: UUID, newValue: ExpenseModel) { }
    func delete(expenseID: UUID) { }
}
