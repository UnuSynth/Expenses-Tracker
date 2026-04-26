//
//  ExpenseGroup.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 21/4/26.
//

import Foundation

struct ExpenseGroup: Identifiable {
    let id: Date
    let label: String
    let items: [ExpenseModel]
}
