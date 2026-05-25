import Foundation

enum Currency: String {
    case usd
    case eur
    case gbp
    case rub
    case kgs
    case kzt
    case uzs

    var symbol: String {
        return .currencySymbol(for: self.rawValue.uppercased())
    }

    var position: SymbolPosition {
        switch self {
        case .usd, .eur, .gbp:
            return .leading
        case .rub, .kgs, .kzt, .uzs:
            return .trailing
        }
    }
}
