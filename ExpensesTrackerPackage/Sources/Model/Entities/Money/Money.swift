import Foundation

enum SymbolPosition {
    case leading
    case trailing
}

struct Money {
    let amount: Double
    let currency: Currency

    var integerPart: String {
        return "\(abs(Int(amount)))"
    }

    var fractionalPart: String {
        let cents = Int(amount.truncatingRemainder(dividingBy: 1.0) * 100)
        return String(format: ".%02d", cents)
    }
}
