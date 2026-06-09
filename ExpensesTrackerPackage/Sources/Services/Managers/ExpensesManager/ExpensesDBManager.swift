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
    func getCount(in category: ExpenseModel.Category) -> Int
    func editExpense(withID id: UUID, newValue: ExpenseModel)
    func deleteExpense(withID id: UUID)
}

@MainActor
final class ExpensesDBManager: ExpensesDBManagerProtocol {
    private let dao: SwiftDataDAOProtocol
    
    init(dao: SwiftDataDAOProtocol) {
        self.dao = dao
    }
    
    func saveExpense(_ expense: ExpenseModel) {
        let status: ()? = try? dao.save(
            model: ExpenseDBModel(model: expense),
            force: true
        )
        
        assert(status != nil, "saveExpense finished unsuccessfully")
    }
    
    func getCount(in category: ExpenseModel.Category) -> Int {
        let count = try? dao.getCount(
            type: ExpenseDBModel.self,
            predicate: #Predicate { $0.category == category }
        )
        
        assert(count != nil, "saveExpense finished unsuccessfully")
        
        return count ?? 0
    }
    
    func editExpense(withID id: UUID, newValue: ExpenseModel) {
        deleteExpense(withID: id)
        saveExpense(newValue)
    }
    
    func deleteExpense(withID id: UUID) {
        let status: ()? = try? dao.delete(
            type: ExpenseDBModel.self,
            predicate: #Predicate { $0.id == id }
        )
        
        assert(status != nil, "saveExpense finished unsuccessfully")
    }
}
