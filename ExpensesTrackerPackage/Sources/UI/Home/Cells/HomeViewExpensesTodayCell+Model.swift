//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

extension HomeViewExpensesTodayCell {
    struct Model {
        let amount: Double
        let currency: String
        let timeStr: String
        
        static func mock() -> Self {
            .init(
                amount: 2600,
                currency: "som",
                timeStr: "3:31 PM"
            )
        }
    }
}
