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

    var body: some View {
        HStack {
            Text(label.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            Text(total, format: .currency(code: Currency.kgs.rawValue.lowercased()))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
        .background(.clear)
    }
}

// MARK: - Expense Row

struct ExpenseListRow: View {
    let expense: ExpenseDBModel

    private var timeText: String {
        expense.date.formatted(.dateTime.hour().minute())
    }
    
    private var titleText: String {
        guard let desc = expense.notes?.desc, !desc.isEmpty else {
            return expense.category.displayName
        }
        
        return desc
    }

    private var subtitleText: String {
        if expense.notes?.desc != nil, expense.notes?.desc?.isEmpty == false {
            return "\(expense.category.displayName) · \(timeText)"
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

            Text(expense.amount, format: .currency(code: Currency.kgs.rawValue.lowercased()))
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Empty State

struct ExpenseListEmptyState: View {
    let category: ExpenseModel.Category?
    let period: Calendar.Period

    private var subtitle: String {
        let periodText = period.description.lowercased()
        if let category {
            return "No \(category.displayName) expenses in \(periodText)."
        } else {
            return "No expenses in \(periodText)."
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("No Results")
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}
