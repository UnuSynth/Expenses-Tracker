import Foundation
import SwiftUI

enum SymbolPosition {
    case leading
    case trailing
}

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

    var displayName: LocalizedStringResource {
        switch self {
        case .usd: return .unitedStates
        case .eur: return .euroMember
        case .gbp: return .unitedKingdom
        case .rub: return .russia
        case .kgs: return .kyrgyzstan
        case .kzt: return .kazakhstan
        }
    }
}
