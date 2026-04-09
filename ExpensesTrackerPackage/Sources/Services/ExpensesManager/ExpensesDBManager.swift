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
}

final class ExpensesDBManager: ExpensesDBManagerProtocol {
    private let dao: SwiftDataDAOProtocol
    
    init() throws {
        let container = try ModelContainer(for: ExpenseDBModel.self)
        let context = ModelContext(container)
        self.dao = SwiftDataDAO(context: context)
    }
    
    func saveExpense(_ expense: ExpenseModel) {
        dao.save(
            model: ExpenseDBModel(model: expense),
            force: true
        )
    }
}
