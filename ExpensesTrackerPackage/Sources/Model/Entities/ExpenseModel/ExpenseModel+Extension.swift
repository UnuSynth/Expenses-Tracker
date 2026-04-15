//
//  ExpenseModel+Extension.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import SwiftUI

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
        
        var icon: String {
            switch self {
            case .groceries: return "cart.fill"
            case .lunch: return "fork.knife"
            case .clothes: return "tshirt.fill"
            case .sport: return "figure.run"
            }
        }
        
        var color: Color {
            switch self {
            case .groceries: return .orange
            case .lunch: return .red
            case .clothes: return .purple
            case .sport: return .green
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
