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
}

final class ExpensesRepository: ExpensesRepositoryProtocol {
    private let expensesDBManager: ExpensesDBManagerProtocol
    
    init(expensesDBManager: ExpensesDBManagerProtocol) {
        self.expensesDBManager = expensesDBManager
    }
    
    func save(expense: ExpenseModel) {
        expensesDBManager.saveExpense(expense)
    }
}

final class ExpensesRepositoryMock: ExpensesRepositoryProtocol {
    func save(expense: ExpenseModel) { }
}
