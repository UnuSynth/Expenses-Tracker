//
//  HomeViewExpensesTodayCell+Model.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//
struct SpendingHeroModel {
    let total: Double
    let currency: String
    let average: Double
    let partnerTotal: Double?
    
    static func mock() -> Self {
        .init(
            total: 1000.0,
            currency: "KGS",
            average: 3500.0,
            partnerTotal: nil
        )
    }
}
