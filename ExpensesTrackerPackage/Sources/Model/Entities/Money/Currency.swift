import Foundation
import SwiftUI

enum Currency: String, CaseIterable {
    case usd
    case eur
    case gbp
    case rub
    case kgs
    case kzt
    
    static func initialize(rawValue: String) -> Self {
        return .init(rawValue: rawValue) ?? .usd
    }

    var symbol: String {
        return .currencySymbol(for: self.rawValue.uppercased())
    }

    var position: SymbolPosition {
        switch self {
        case .usd, .eur, .gbp:
            return .leading
        case .rub, .kgs, .kzt:
            return .trailing
        }
    }

    var displayName: String {
        switch self {
        case .usd: return "United States"
        case .eur: return "Euro Member"
        case .gbp: return "United Kingdom"
        case .rub: return "Russia"
        case .kgs: return "Kyrgyzstan"
        case .kzt: return "Kazakhstan"
        }
    }
}
