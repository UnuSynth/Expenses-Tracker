//
//  TransactionsHistoryTransactionsSection.swift
//  ExpensesTrackerPackage
//

import SwiftUI

struct TransactionsHistoryTransactionsSection: View {
    let groups: [ExpenseGroup]
    @State private var showAllTransactions = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRANSACTIONS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

            let displayGroups = showAllTransactions ? groups : Array(groups.prefix(3))

            ForEach(displayGroups) { group in
                transactionGroupSection(group: group)
            }

            if groups.count > 3 {
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        showAllTransactions.toggle()
                    }
                } label: {
                    HStack {
                        Text(showAllTransactions ? "Show Less" : "Show All Transactions")
                            .font(.subheadline)
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                        Image(systemName: showAllTransactions ? "chevron.up" : "chevron.down")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func transactionGroupSection(group: ExpenseGroup) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(group.label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background.secondary)

            ForEach(group.items.indices, id: \.self) { index in
                let expense = group.items[index]
                transactionRow(expense: expense)
                    .padding(.horizontal, 16)

                if index < group.items.count - 1 {
                    Divider().padding(.leading, 68)
                }
            }
        }
    }

    private func transactionRow(expense: ExpenseModel) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: expense.category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(expense.category.color)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(expense.category.displayName)
                    .font(.body)
                    .foregroundStyle(.primary)
                if let notes = expense.notes, let desc = notes.desc, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.amount, format: .currency(code: "USD"))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(expense.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
