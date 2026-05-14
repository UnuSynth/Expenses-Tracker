//
//  HighlightsStrip.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 26/4/26.
//

import SwiftUI

struct HighlightsStrip: View {
    let transactions: [ExpenseModel]

    private var highlights: [AnyHighlight] {
        var result: [AnyHighlight] = []

        // Highest single day
        let grouped = Dictionary(grouping: transactions) { Calendar.current.startOfDay(for: $0.date) }
        if let (day, txs) = grouped.max(by: { $0.value.reduce(0) { $0 + $1.amount } < $1.value.reduce(0) { $0 + $1.amount } }) {
            let total = txs.reduce(0) { $0 + $1.amount }
            let label = Calendar.current.isDateInYesterday(day) ? "Yesterday" :
                        Calendar.current.isDateInToday(day) ? "Today" :
                        day.formatted(.dateTime.weekday(.wide))
            result.append(AnyHighlight(
                icon: "chart.bar.fill", color: .accentColor,
                headline: "Highest Day",
                value: total.formatted(.currency(code: "USD").presentation(.narrow)),
                sub: label
            ))
        }

        // Most used category
        let byCat = Dictionary(grouping: transactions) { $0.category.displayName }
        if let (catName, catTxs) = byCat.max(by: { $0.value.count < $1.value.count }),
           let cat = catTxs.first?.category {
            result.append(AnyHighlight(
                icon: cat.icon, color: cat.color,
                headline: "Top Category",
                value: catName,
                sub: "\(catTxs.count) transactions"
            ))
        }

        // vs. last month
        let now = Date.now
        let cal = Calendar.current
        let thisMonthStart = cal.dateInterval(of: .month, for: now)?.start ?? now
        let lastMonthStart = cal.date(byAdding: .month, value: -1, to: thisMonthStart) ?? now
        let thisTotal = transactions.filter { $0.date >= thisMonthStart }.reduce(0) { $0 + $1.amount }
        let lastTotal = transactions.filter { $0.date >= lastMonthStart && $0.date < thisMonthStart }.reduce(0) { $0 + $1.amount }
        if lastTotal > 0 {
            let pct = ((thisTotal - lastTotal) / lastTotal) * 100
            let more = pct >= 0
            result.append(AnyHighlight(
                icon: more ? "arrow.up.circle.fill" : "arrow.down.circle.fill",
                color: more ? .red : .green,
                headline: "vs. Last Month",
                value: String(format: "%+.0f%%", pct),
                sub: more ? "Spent more" : "Spent less"
            ))
        }

        return result
    }

    var body: some View {
        if highlights.count >= 2 {
            VStack(alignment: .leading, spacing: 0) {
                Text("Highlights")
                    .font(.title3)
                    .bold()
                    .padding(.leading, 16)
                    .padding(.bottom, 12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(highlights) { h in
                            HighlightCard(icon: h.icon, iconColor: h.color,
                                          headline: h.headline, value: h.value, sub: h.sub)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

struct AnyHighlight: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let headline: String
    let value: String
    let sub: String
}
