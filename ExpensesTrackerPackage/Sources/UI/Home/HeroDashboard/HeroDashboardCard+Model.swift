//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

struct HeroDashboardModel: Equatable {
    let chips: [ChipModel]
    var currency: Currency = .usd
    var total: Double {
        chips.reduce(into: 0) { result, chip in
            result += chip.amount
        }
    }

    /// Total for the selected category, or the grand total when nothing is selected, in this model's currency.
    func money(for selectedCategory: CategoryModel?) -> Money {
        .init(
            amount: chips.first { $0.category == selectedCategory }?.amount ?? total,
            currency: currency
        )
    }

    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        return lhs.total == rhs.total
        && lhs.currency == rhs.currency
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
