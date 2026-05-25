//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

struct HeroDashboardModel {
    let chips: [ChipModel]
    var total: Double {
        chips.reduce(into: 0) { result, chip in
            result += chip.amount
        }
    }
    
    struct ChipModel: Identifiable {
        var id: ExpenseModel.Category { category }
        let amount: Double
        let category: ExpenseModel.Category
        
        func toSpendingBarSegment() -> SpendingBarSegment {
            .init(color: category.color, value: amount)
        }
    }
}
