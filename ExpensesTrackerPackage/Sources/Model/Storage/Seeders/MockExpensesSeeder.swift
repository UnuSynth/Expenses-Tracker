//
//  MockExpensesSeeder.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 18/6/26.
//

import Foundation
import SwiftData

public enum ExpensesSeeder {
    public static func seed(into context: ModelContext) {
        guard (try? context.fetchCount(FetchDescriptor<ExpenseDBModel>())) ?? 0 == 0 else {
            return
        }
        
        let categories: [CategoryModel] = (try? context.fetch(.init())) ?? []
        guard !categories.isEmpty else { return }

        let now = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        let interval = now.timeIntervalSince(oneYearAgo)

        for i in 0..<150 {
            let randomOffset = Double(i) / 150.0 * interval + Double(i % 7) * 86400
            let date = oneYearAgo.addingTimeInterval(randomOffset.truncatingRemainder(dividingBy: interval))
            let amount = Double(Int.random(in: 1...12_000))
            let category = categories[i % categories.count]

            let expense = ExpenseDBModel(date: date, amount: amount, category: category)
            context.insert(expense)
        }
    }
}
