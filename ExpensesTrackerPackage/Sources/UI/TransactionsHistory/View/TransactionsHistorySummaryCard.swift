//
//  TransactionsHistorySummaryCard.swift
//  ExpensesTrackerPackage
//

import SwiftUI

struct TransactionsHistorySummaryCard: View {
    let summaryAmount: Double
    let summaryTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("EXPENSES")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(summaryAmount, format: .currency(code: "USD"))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: summaryAmount)

            Text(summaryTitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
