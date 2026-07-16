//
//  CurrencySettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

struct CurrencySettingsView: View {
    @SelectedCurrency private var selectedCurrency: Currency

    var body: some View {
        List(Currency.allCases, id: \.rawValue) { currency in
            Button {
                selectedCurrency = currency
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
        .navigationTitle(Text(.currency))
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CurrencySettingsView()
    }
}
