//
//  TransactionsHistoryMockViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 21/4/26.
//

import Foundation

extension TransactionsHistoryView {
    @Observable
    class MockViewModel: ViewModel {
        var selectedPeriod: TimePeriod = .week
        var selectedBarDate: Date? = nil
        var isLoading: Bool = false
        var errorMessage: String? = nil
        
        private let mockExpenses: [ExpenseModel] = {
            let calendar = Calendar.current
            let now = Date.now
            let categories: [ExpenseModel.Category] = [.groceries, .lunch, .clothes, .sport]
            let notes: [String?] = [
                "Weekly shopping", "Coffee with friends", nil, "Gym membership",
                "New jacket", nil, "Protein bars", "Bus ticket",
                "Team lunch", nil, "Running shoes", "Dinner"
            ]
            
            var expenses: [ExpenseModel] = []
            for dayOffset in 0..<460 {
                guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
                let expensesPerDay = dayOffset % 3 == 0 ? 3 : (dayOffset % 2 == 0 ? 2 : 1)
                
                for i in 0..<expensesPerDay {
                    let hour = 8 + i * 4
                    let expenseDate = calendar.date(bySettingHour: hour, minute: 30, second: 0, of: date) ?? date
                    let amount = Double.random(in: 5...10000)
                    let category = categories[(dayOffset + i) % categories.count]
                    let note = notes[(dayOffset + i) % notes.count]
                    
                    expenses.append(
                        ExpenseModel(
                            date: expenseDate,
                            amount: (amount * 100).rounded() / 100,
                            category: category,
                            notes: note.map { .init(desc: $0) }
                        )
                    )
                }
            }
            return expenses
        }()
        
        var chartData: [ChartDataPoint] {
            let calendar = Calendar.current
            let range = selectedPeriod.dateRange
            let component = selectedPeriod.calendarComponent
            
            let filtered = mockExpenses.filter {
                $0.date >= range.start && $0.date <= range.end
            }
            
            let grouped = Dictionary(grouping: filtered) { expense -> Date in
                switch component {
                case .hour:
                    return calendar.date(
                        from: calendar.dateComponents([.year, .month, .day, .hour], from: expense.date)
                    ) ?? expense.date
                case .day:
                    return calendar.startOfDay(for: expense.date)
                default:
                    return calendar.startOfDay(for: expense.date)
                }
            }
            
            var points: [ChartDataPoint] = []
            var current: Date
            switch component {
            case .hour:
                current = calendar.date(
                    from: calendar.dateComponents([.year, .month, .day, .hour], from: range.start)
                ) ?? range.start
            default:
                current = calendar.startOfDay(for: range.start)
            }
            
            while current <= range.end {
                let total = grouped[current]?.reduce(0) { $0 + $1.amount } ?? 0
                points.append(ChartDataPoint(dateStart: current, dateEnd: range.end, total: total))
                guard let next = calendar.date(byAdding: component, value: 1, to: current) else { break }
                current = next
            }
            
            return points
        }
        
        var groupedTransactions: [ExpenseGroup] {
            let calendar = Calendar.current
            let range = selectedPeriod.dateRange
            
            let filtered = mockExpenses
                .filter { $0.date >= range.start && $0.date <= range.end }
                .sorted { $0.date > $1.date }
            
            let grouped = Dictionary(grouping: filtered) { expense in
                calendar.startOfDay(for: expense.date)
            }
            
            return grouped
                .sorted { $0.key > $1.key }
                .map { date, expenses in
                    ExpenseGroup(id: date, label: date.relativeLabel, items: expenses)
                }
        }
        
        func loadExpenses() { }
    }
}
