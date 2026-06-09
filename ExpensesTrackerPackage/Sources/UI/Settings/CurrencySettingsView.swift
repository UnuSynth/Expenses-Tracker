//
//  CurrencySettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

struct CurrencySettingsView: View {
    @AppStorage("selectedCurrency") private var selectedCurrencyRaw: String = Currency.usd.rawValue

    private var selectedCurrency: Currency {
        Currency(rawValue: selectedCurrencyRaw) ?? Currency.usd
    }

    var body: some View {
        List(Currency.allCases, id: \.rawValue) { currency in
            Button {
                selectedCurrencyRaw = currency.rawValue
            } label: {
                HStack {
                    Text(currency.symbol)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    Text(currency.displayName)
                        .foregroundStyle(.primary)
                    Spacer()
                    if selectedCurrency == currency {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .fontWeight(.semibold)
                    }
                }
            }
            .foregroundStyle(.primary)
            
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.background.secondary)
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CurrencySettingsView()
    }
}
