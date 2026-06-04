//
//  ExpensesManager.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 19/2/26.
//

import Foundation
import SwiftData

@MainActor
protocol ExpensesDBManagerProtocol {
    func saveExpense(_ expense: ExpenseModel)
    func editExpense(withID id: UUID, newValue: ExpenseModel)
    func deleteExpense(withID id: UUID)
    func deleteExpense(_ expense: ExpenseDBModel)
}

@MainActor
final class ExpensesDBManager: ExpensesDBManagerProtocol {
    private let dao: SwiftDataDAOProtocol
    
    init(dao: SwiftDataDAOProtocol) {
        self.dao = dao
    }
    
    func saveExpense(_ expense: ExpenseModel) {
        dao.save(
            model: ExpenseDBModel(model: expense),
            force: true
        )
    }
    
    func editExpense(withID id: UUID, newValue: ExpenseModel) {
        deleteExpense(withID: id)
        saveExpense(newValue)
    }
    
    func deleteExpense(withID id: UUID) {
        guard let model = fetchExpense(withID: id) else { return }
        deleteExpense(model)
    }
    
    func deleteExpense(_ expense: ExpenseDBModel) {
        dao.delete(model: expense)
    }
    
    private func fetchExpense(withID id: UUID) -> ExpenseDBModel? {
        let predicate = #Predicate<ExpenseDBModel> { $0.id == id }
        return try? dao.get(model: ExpenseDBModel.self, predicate: predicate).first
    }
}
