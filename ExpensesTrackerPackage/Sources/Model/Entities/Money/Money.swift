import Foundation

struct Money {
    let amount: Decimal
    let currency: Currency

    init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }

    // ponytail: DB persists `amount` as Double; convert at this boundary.
    // True fix is Decimal all the way from ExpenseDBModel — needs a SwiftData migration.
    init(amount: Double, currency: Currency) {
        self.init(amount: Decimal(amount), currency: currency)
    }

    /// `amount` rounded to 2 fraction digits (round-half-up). Also scrubs the
    /// imprecision introduced by `Decimal(Double)` at construction.
    private var rounded: Decimal {
        var result = Decimal()
        var value = amount
        NSDecimalRound(&result, &value, 2, .plain)
        return result
    }

    /// Integer digits of the absolute value, no grouping separators. e.g. 19.99 -> "19".
    var integerPart: String {
        var whole = Decimal()
        var magnitude = rounded.magnitude
        NSDecimalRound(&whole, &magnitude, 0, .down)
        return NSDecimalNumber(decimal: whole).stringValue
    }

    /// Two-digit cents with leading dot. e.g. 19.99 -> ".99", 19.0 -> ".00".
    var fractionalPart: String {
        let magnitude = rounded.magnitude
        var whole = Decimal()
        var value = magnitude
        NSDecimalRound(&whole, &value, 0, .down)
        let cents = (magnitude - whole) * 100
        return String(format: ".%02d", NSDecimalNumber(decimal: cents).intValue)
    }
}
