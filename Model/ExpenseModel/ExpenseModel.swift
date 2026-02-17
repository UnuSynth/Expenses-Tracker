//
//  ExpenseModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

struct Expense {
    let date: Date
    let amount: Double
    let category: String
    let notes: ExpenseNotes?
}

extension Expense {
    struct ExpenseNotes {
        let description: String?
        let image: Image?
    }
}
