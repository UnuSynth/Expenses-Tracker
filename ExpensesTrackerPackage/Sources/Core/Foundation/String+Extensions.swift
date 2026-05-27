//
//  String.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/4/26.
//

import Foundation

extension String {
    static let som = "c̲"
    
    static func currencySymbol(for code: String) -> String {
        switch code {
        case "USD": return "$"
        case "EUR": return "€"
        case "GBP": return "£"
        case "RUB": return "₽"
        case "KGS": return .som
        case "KZT": return "₸"
        case "UZS": return "so'm"
        default:    return code
        }
    }
    
    func toDouble() -> Double? {
        guard last != "," else { return nil } // ensure that user finished number input
        
        return Double(
            self.replacingOccurrences(
                of: ",",
                with: "."
            )
        )
    }
}
