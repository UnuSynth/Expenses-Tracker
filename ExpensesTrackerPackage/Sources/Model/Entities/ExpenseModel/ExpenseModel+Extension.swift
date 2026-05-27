//
//  ExpenseModel+Extension.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import SwiftUI

extension ExpenseModel {
    enum Category: String, CaseIterable, Identifiable {
        case clothes
        case groceries
        case lunch
        case sport
        case transport
        case entertainment
        case health
        case utilities
        
        var id: String { self.rawValue }
        
        var displayName: String {
            switch self {
            case .clothes:
                return "Clothes"
            case .groceries:
                return "Groceries"
            case .lunch:
                return "Lunch"
            case .sport:
                return "Sport"
            case .transport:
                return "Transport"
            case .entertainment:
                return "Entertainment"
            case .health:
                return "Health"
            case .utilities:
                return "Utilities"
            }
        }
        
        var icon: String {
            switch self {
            case .clothes: return "tshirt.fill"
            case .groceries: return "cart.fill"
            case .lunch: return "fork.knife"
            case .sport: return "figure.run"
            case .transport: return "car.fill"
            case .entertainment: return "popcorn.fill"
            case .health: return "heart.fill"
            case .utilities: return "bolt.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .clothes: return .purple
            case .groceries: return .green
            case .lunch: return .orange
            case .sport: return .indigo
            case .transport: return .blue
            case .entertainment: return .purple
            case .health: return .red
            case .utilities: return .yellow
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
