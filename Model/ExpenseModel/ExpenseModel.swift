//
//  ExpenseModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//
import Foundation

struct ExpenseModel {
    let date: Date
    let amount: Double
    let category: Category
    let notes: Notes?
    
    init(
        date: Date,
        amount: Double,
        category: Category,
        notes: Notes? = nil
    ) {
        self.date = date
        self.amount = amount
        self.category = category
        self.notes = notes
    }
}
