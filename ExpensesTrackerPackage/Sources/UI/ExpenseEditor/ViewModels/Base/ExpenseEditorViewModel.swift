//
//  ExpenseEditorViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 2/6/26.
//

import Foundation

@MainActor
protocol ExpenseEditorViewModel: AnyObject, Observable {
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

extension ExpenseEditorViewModel {
    var amountDouble: Double? {
        amountString.toDouble()
    }
    
    var isValid: Bool {
        amountString.isEmpty == false
        && amountDouble != nil
        && amountDouble != 0
    }
    
    var datesRange: ClosedRange<Date> {
        // a date range between 20 years ago and now
        Date.now.addingTimeInterval(-1*3600*24*365*20)...Date.now
    }
    
    var categories: [ExpenseModel.Category] {
        ExpenseModel.Category.allCases
    }
}
