import SwiftUI

struct TotalMoney: View {
    let money: Money

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            if money.currency.position == .leading {
                moneySymbol
                    .offset(y: -10)
            }

            Text(money.integerPart)
                .font(.system(size: 48, weight: .bold))
                .lineLimit(1)

            if money.fractionalPart != ".00" {
                Text(money.fractionalPart)
                    .lineLimit(1)
                    .offset(y: money.currency.position == .leading ? -12 : 0)
                    .font(.system(size: money.currency.position == .leading ? 24 : 48, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }

            if money.currency.position == .trailing {
                moneySymbol
                    .padding(.leading, 8)
            }
        }
    }
    
    private var moneySymbol: some View {
        Text(money.currency.symbol)
            .lineLimit(1)
            .font(.title2.bold())
    }
}

#Preview {
    VStack(spacing: 24) {
        TotalMoney(money: Money(amount: 1_234.56, currency: .usd))
        TotalMoney(money: Money(amount: 98_765.00, currency: .kgs))
        TotalMoney(money: Money(amount: 450_000.75, currency: .kzt))
    }
    .padding()
}
