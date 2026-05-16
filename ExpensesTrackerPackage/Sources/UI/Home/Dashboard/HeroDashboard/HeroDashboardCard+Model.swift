//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//
struct HeroDashboardModel {
    let dateTitle: String
    let total: Double
    let categories: [Category]
    
    struct Category {
        let total: Double
        let category: ExpenseModel.Category
        
        func toSpendingBarSegment() -> SpendingBarSegment {
            .init(color: category.color, value: total)
        }
    }
}
