//
//  ExpenseEditorViewModel+Mock.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 2/6/26.
//

import Foundation

@Observable
@MainActor
class ExpenseEditorViewModelMock: ExpenseEditorViewModel {
    var date: Date = .now
    var amountString: String = ""
    var category: ExpenseModel.Category = .groceries
    var notes: String = ""
    func saveExpense() { }
}
