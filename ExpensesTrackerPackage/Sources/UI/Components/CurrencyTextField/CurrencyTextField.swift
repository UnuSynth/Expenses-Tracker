//
//  CurrencyTextField.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 28/5/26.
//

import SwiftUI

struct CurrencyTextField: View {
    let currency: Currency
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            if currency.position == .leading {
                symbolView
                    .offset(y: -32)
            }
            amountDisplay
            if currency.position == .trailing {
                symbolView
                    .padding(.leading, 8)
            }
        }
    }

    private var symbolView: some View {
        Text(currency.symbol)
            .font(.title.weight(.semibold))
            .foregroundStyle(.secondary)
    }

    private var amountDisplay: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            let (integer, fraction) = splitAmount()
            Text(integer)
                .font(.system(size: 96, weight: .bold))
                .foregroundStyle(text.isEmpty ? .tertiary : .primary)
            if let fraction {
                Text(fraction)
                    .font(.system(size: 96, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .onChange(of: text) { old, new in
            text = filtered(old: old, new: new)
        }
        .fixedSize()
    }

    private func splitAmount() -> (String, String?) {
        let sep = String.decimalSeparator
        guard !text.isEmpty else { return ("0", nil) }
        let parts = text.components(separatedBy: sep)
        guard parts.count > 1 else { return (text, nil) }
        return (parts[0], sep + parts[1])
    }

    private func filtered(old: String, new: String) -> String {
        let sep = String.decimalSeparator
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: sep))
        let clean = String(new.unicodeScalars.filter { allowed.contains($0) }.map(Character.init))
        return clean.components(separatedBy: sep).count - 1 > 1 ? old : clean
    }
}

#Preview {
    VStack(spacing: 32) {
        CurrencyTextField(currency: .usd, text: .constant("24.50"))
        CurrencyTextField(currency: .kgs, text: .constant("103.50"))
        CurrencyTextField(currency: .kzt, text: .constant("1200"))
    }
    .padding()
}
