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
    
    func fetchAllExpenses() throws -> [ExpenseModel]
}

final class ExpensesDBManager: ExpensesDBManagerProtocol {
    private let dao: SwiftDataDAOProtocol
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        self.dao = SwiftDataDAO(context: context)
    }
    
    func saveExpense(_ expense: ExpenseModel) {
        dao.save(
            model: ExpenseDBModel(model: expense),
            force: true
        )
    }
    
    func fetchAllExpenses() throws -> [ExpenseModel] {
        let dbModels: [ExpenseDBModel] = try dao.get(model: ExpenseDBModel.self)
        return dbModels.map { $0.toEntity() }
    }
}
