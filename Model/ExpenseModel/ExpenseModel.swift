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
    let category: String
    let notes: Notes?
}


extension ExpenseModel {
    enum Category: String, CaseIterable, Identifiable {
        case groceries
        case lunch
        case clothes
        case sport
        
        var id: String { self.rawValue }
        
        var displayName: String {
            switch self {
            case .groceries:
                return "🛒 Groceries"
            case .lunch:
                return "🍽️ Lunch"
            case .clothes:
                return "👗 Clothes"
            case .sport:
                return "🏀 Sport"
            }
        }
    }
    
    struct Notes {
        let description: String?
        let image: String?
    }
}
