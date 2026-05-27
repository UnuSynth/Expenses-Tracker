import SwiftUI

struct TotalMoney: View {
    let money: Money

    var body: some View {
        HStack(spacing: 2) {
            if money.currency.position == .leading {
                moneySymbol
                    .offset(y: -5)
            }

            Text(money.integerPart)
                .font(.system(size: 48, weight: .bold))
                .lineLimit(1)

            Text(money.fractionalPart)
                .lineLimit(1)
                .offset(y: -5)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.tertiary)

            if money.currency.position == .trailing {
                moneySymbol
                    .offset(y: -5)
            }
        }
    }
    
    private var moneySymbol: some View {
        Text(money.currency.symbol)
            .lineLimit(1)
            .font(.title2.bold())
    }
}
