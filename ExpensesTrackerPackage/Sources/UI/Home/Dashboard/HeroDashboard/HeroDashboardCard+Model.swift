//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

struct HeroDashboardModel {
    let dateTitle: String
    let total: Double
    let chips: [ChipModel]
    
    struct ChipModel: Identifiable {
        let id = UUID()
        let total: Double
        let category: ExpenseModel.Category
        
        func toSpendingBarSegment() -> SpendingBarSegment {
            .init(color: category.color, value: total)
        }
    }
}
