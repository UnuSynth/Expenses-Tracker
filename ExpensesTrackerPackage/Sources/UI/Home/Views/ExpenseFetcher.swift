//
//  ExpenseFetcher.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 7/7/26.
//

import SwiftUI
import SwiftData

struct ExpenseFetcher: View {
    @Query private var expenses: [ExpenseDBModel]
    private let onExpensesChange: ([ExpenseDBModel]) -> Void

    init(period: Calendar.Period, onExpensesChange: @escaping ([ExpenseDBModel]) -> Void) {
        let (start, end) = period.dates
        _expenses = Query(
            filter: #Predicate<ExpenseDBModel> { $0.date >= start && $0.date <= end },
            sort: \.date,
            order: .reverse
        )
        self.onExpensesChange = onExpensesChange
    }

    var body: some View {
        Color.clear
            .onChange(of: expenses, initial: true) { _, newExpenses in
                onExpensesChange(newExpenses)
            }
    }
}
