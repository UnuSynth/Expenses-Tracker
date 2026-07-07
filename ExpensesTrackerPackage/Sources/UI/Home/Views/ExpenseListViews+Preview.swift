//
//  ExpenseListViews+Preview.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

// MARK: - Previews

private extension CategoryModel {
    nonisolated(unsafe) static let groceries = CategoryModel(name: "Groceries", icon: "cart.fill", color: .green)
    nonisolated(unsafe) static let lunch = CategoryModel(name: "Lunch", icon: "fork.knife", color: .orange)
    nonisolated(unsafe) static let transport = CategoryModel(name: "Transport", icon: "car.fill", color: .blue)
    nonisolated(unsafe) static let clothes = CategoryModel(name: "Clothes", icon: "tshirt.fill", color: .purple)
    nonisolated(unsafe) static let entertainment = CategoryModel(name: "Entertainment", icon: "popcorn.fill", color: .purple)
    nonisolated(unsafe) static let health = CategoryModel(name: "Health", icon: "heart.fill", color: .red)
    nonisolated(unsafe) static let utilities = CategoryModel(name: "Utilities", icon: "bolt.fill", color: .yellow)
    nonisolated(unsafe) static let sport = CategoryModel(name: "Sport", icon: "figure.run", color: .indigo)
}

private extension ExpenseDBModel {
    static func mock(
        amount: Double,
        category: CategoryModel,
        hoursAgo: Double = 0,
        notes: Notes? = nil
    ) -> ExpenseDBModel {
        ExpenseDBModel(
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
            .mock(amount: 42.50, category: .groceries, hoursAgo: 1, notes: .init(desc: "Weekly groceries")),
            .mock(amount: 18.00, category: .lunch, hoursAgo: 3, notes: .init(desc: "Sushi lunch")),
            .mock(amount: 6.50, category: .transport, hoursAgo: 5)
        ]),
        ("Yesterday", [
            .mock(amount: 120.00, category: .clothes, hoursAgo: 26, notes: .init(desc: "New jacket")),
            .mock(amount: 35.00, category: .entertainment, hoursAgo: 28),
            .mock(amount: 50.00, category: .health, hoursAgo: 30, notes: .init(desc: "Pharmacy")),
            .mock(amount: 80.00, category: .utilities, hoursAgo: 32)
        ]),
        ("Monday", [
            .mock(amount: 22.00, category: .lunch, hoursAgo: 50),
            .mock(amount: 67.00, category: .groceries, hoursAgo: 52),
            .mock(amount: 30.00, category: .sport, hoursAgo: 54, notes: .init(desc: "Gym membership"))
        ]),
        ("Last Week", [
            .mock(amount: 15.00, category: .transport, hoursAgo: 100),
            .mock(amount: 95.00, category: .utilities, hoursAgo: 104, notes: .init(desc: "Internet bill"))
        ]),
        ("Earlier", [
            .mock(amount: 200.00, category: .clothes, hoursAgo: 200),
            .mock(amount: 45.00, category: .lunch, hoursAgo: 202, notes: .init(desc: "Team dinner")),
            .mock(amount: 60.00, category: .entertainment, hoursAgo: 204),
            .mock(amount: 30.00, category: .health, hoursAgo: 206),
            .mock(amount: 88.00, category: .groceries, hoursAgo: 208)
        ])
    ]
    List {
        ForEach(groups, id: \.0) { label, expenses in
            Section {
                ForEach(expenses, id: \.id) { expense in
                    ExpenseListRow(expense: expense, currency: .usd)
                        .listRowInsets(.init())
                }
            } header: {
                ExpenseListSectionHeader(
                    label: label,
                    total: expenses.reduce(0) { $0 + $1.amount },
                    currency: .usd
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
                total: total,
                currency: .usd
            )
            Divider()
        }
    }
    .padding(.horizontal)
}
