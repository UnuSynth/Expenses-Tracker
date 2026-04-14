//
//  ExpenseModel+Extension.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

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
                return "Groceries 🛒"
            case .lunch:
                return "Lunch 🍽️"
            case .clothes:
                return "Clothes 👗"
            case .sport:
                return "Sport 🏀"
            }
        }
    }
    
    struct Notes {
        let desc: String?
        let image: String?
        
        init(desc: String? = nil, image: String? = nil) {
            self.desc = desc
            self.image = image
        }
    }
}
