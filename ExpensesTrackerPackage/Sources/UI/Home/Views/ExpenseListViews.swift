//
//  Heofn.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 30/5/26.
//

import SwiftUI

// MARK: - Section Header

struct ExpenseListSectionHeader: View {
    let label: String
    let total: Double
    let currency: Currency

    var body: some View {
        HStack {
            Text(label.uppercased())
                .font(.footnote.bold())
                .foregroundStyle(.primary)
            Spacer()
            Text(total.formatted(currency: currency))
                .font(.footnote.bold())
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 4)
        .background(.clear)
    }
}

// MARK: - Expense Row

struct ExpenseListRow: View {
    let expense: ExpenseDBModel
    let currency: Currency

    @Environment(\.locale) private var locale

    private var timeText: String {
        expense.date.formatted(.dateTime.hour().minute().locale(locale))
    }
    
    private var titleText: String {
        guard let desc = expense.notes?.desc, !desc.isEmpty else {
            return expense.category.displayName(locale: locale)
        }
        return desc
    }

    private var subtitleText: String {
        if expense.notes?.desc != nil, expense.notes?.desc?.isEmpty == false {
            return "\(expense.category.displayName(locale: locale)) · \(timeText)"
        } else {
            return timeText
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: expense.category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(expense.category.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titleText)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(subtitleText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(expense.amount.formatted(currency: currency))
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Empty State

struct ExpenseListEmptyState: View {
    let category: CategoryModel?
    let period: Calendar.Period

    @Environment(\.locale) private var locale

    var body: some View {
        VStack(spacing: 6) {
            Text(.noResults)
                .font(.headline)
                .foregroundStyle(.primary)
            if let category {
                Text(.noExpenses(category.displayName(locale: locale), in: period.description(locale: locale).lowercased()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text(.noExpensesIn(period.description(locale: locale).lowercased()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}
