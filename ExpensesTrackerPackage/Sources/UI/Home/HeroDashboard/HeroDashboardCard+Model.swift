//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

struct HeroDashboardModel: Equatable {
    let chips: [ChipModel]
    var total: Double {
        chips.reduce(into: 0) { result, chip in
            result += chip.amount
        }
    }
    
    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        return lhs.total == rhs.total
        && lhs.chips.count == rhs.chips.count
        && lhs.chips == rhs.chips
    }
    
    struct ChipModel: Equatable, Identifiable {
        var id: CategoryModel { category }
        let amount: Double
        let category: CategoryModel
        
        func toSpendingBarSegment() -> SpendingBarSegment {
            .init(id: category.name, color: category.color, value: amount)
        }
    }
}
