//
//  ExpenseListViews+Preview.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

// MARK: - Previews

private extension ExpenseModel {
    static func mock(
        amount: Double,
        category: Category,
        hoursAgo: Double = 0,
        notes: Notes? = nil
    ) -> ExpenseModel {
        ExpenseModel(
            date: Date(timeIntervalSinceNow: -hoursAgo * 3600),
            amount: amount,
            category: category,
            notes: notes
        )
    }
}

#Preview("Expense Rows") {
    let groups: [(String, [ExpenseDBModel])] = [
        ("Today", [
            ExpenseDBModel(model: .mock(amount: 42.50, category: .groceries, hoursAgo: 1, notes: .init(desc: "Weekly groceries"))),
            ExpenseDBModel(model: .mock(amount: 18.00, category: .lunch, hoursAgo: 3, notes: .init(desc: "Sushi lunch"))),
            ExpenseDBModel(model: .mock(amount: 6.50, category: .transport, hoursAgo: 5))
        ]),
        ("Yesterday", [
            ExpenseDBModel(model: .mock(amount: 120.00, category: .clothes, hoursAgo: 26, notes: .init(desc: "New jacket"))),
            ExpenseDBModel(model: .mock(amount: 35.00, category: .entertainment, hoursAgo: 28)),
            ExpenseDBModel(model: .mock(amount: 50.00, category: .health, hoursAgo: 30, notes: .init(desc: "Pharmacy"))),
            ExpenseDBModel(model: .mock(amount: 80.00, category: .utilities, hoursAgo: 32))
        ]),
        ("Monday", [
            ExpenseDBModel(model: .mock(amount: 22.00, category: .lunch, hoursAgo: 50)),
            ExpenseDBModel(model: .mock(amount: 67.00, category: .groceries, hoursAgo: 52)),
            ExpenseDBModel(model: .mock(amount: 30.00, category: .sport, hoursAgo: 54, notes: .init(desc: "Gym membership")))
        ]),
        ("Last Week", [
            ExpenseDBModel(model: .mock(amount: 15.00, category: .transport, hoursAgo: 100)),
            ExpenseDBModel(model: .mock(amount: 95.00, category: .utilities, hoursAgo: 104, notes: .init(desc: "Internet bill")))
        ]),
        ("Earlier", [
            ExpenseDBModel(model: .mock(amount: 200.00, category: .clothes, hoursAgo: 200)),
            ExpenseDBModel(model: .mock(amount: 45.00, category: .lunch, hoursAgo: 202, notes: .init(desc: "Team dinner"))),
            ExpenseDBModel(model: .mock(amount: 60.00, category: .entertainment, hoursAgo: 204)),
            ExpenseDBModel(model: .mock(amount: 30.00, category: .health, hoursAgo: 206)),
            ExpenseDBModel(model: .mock(amount: 88.00, category: .groceries, hoursAgo: 208))
        ])
    ]
    List {
        ForEach(groups, id: \.0) { label, expenses in
            Section {
                ForEach(expenses, id: \.id) { expense in
                    ExpenseListRow(expense: expense)
                        .listRowInsets(.init())
                }
            } header: {
                ExpenseListSectionHeader(
                    label: label,
                    total: expenses.reduce(0) { $0 + $1.amount }
                )
            }
        }
    }
    .listStyle(.plain)
}

#Preview("Section Headers") {
    let groups: [(String, Double)] = [
        ("Today", 67.00),
        ("Yesterday", 285.00),
        ("Monday", 119.00),
        ("Last Week", 110.00),
        ("Earlier", 423.00)
    ]
    VStack(spacing: 0) {
        ForEach(groups, id: \.0) { label, total in
            ExpenseListSectionHeader(
                label: label,
                total: total
            )
            Divider()
        }
    }
    .padding(.horizontal)
}
