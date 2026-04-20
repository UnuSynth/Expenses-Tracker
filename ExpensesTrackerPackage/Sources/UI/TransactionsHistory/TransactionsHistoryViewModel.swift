//
//  TransactionsHistoryViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/4/26.
//

import Foundation
import SwiftUI

extension TransactionsHistoryView {
    enum TimePeriod: String, CaseIterable {
        case day = "D"
        case week = "W"
        case month = "M"
        case sixMonths = "6M"
        case year = "Y"
        
        var rangeLabel: String {
            switch self {
            case .day: return "Today"
            case .week: return "This Week"
            case .month: return "This Month"
            case .sixMonths: return "Last 6 Months"
            case .year: return "This Year"
            }
        }
        
        var calendarComponent: Calendar.Component {
            switch self {
            case .day: return .hour
            case .week: return .day
            case .month: return .day
            case .sixMonths: return .weekOfYear
            case .year: return .month
            }
        }
        
        var dateRange: (start: Date, end: Date) {
            let calendar = Calendar.current
            let now = Date.now
            let end = calendar.endOfDay(for: now)
            
            let start: Date
            switch self {
            case .day:
                start = calendar.startOfDay(for: now)
            case .week:
                start = calendar.date(
                    from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
                ) ?? now
            case .month:
                start = calendar.date(
                    from: calendar.dateComponents([.year, .month], from: now)
                ) ?? now
            case .sixMonths:
                start = calendar.date(byAdding: .month, value: -6, to: calendar.startOfDay(for: now)) ?? now
            case .year:
                start = calendar.date(
                    from: calendar.dateComponents([.year], from: now)
                ) ?? now
            }
            
            return (start, end)
        }
    }
    
    struct ChartDataPoint: Identifiable {
        let id: Date
        let date: Date
        let total: Double
        
        init(date: Date, total: Double) {
            self.id = date
            self.date = date
            self.total = total
        }
    }
    
    struct ExpenseGroup: Identifiable {
        let id: Date
        let label: String
        let items: [ExpenseModel]
    }
    
    protocol ViewModel: AnyObject {
        var selectedPeriod: TimePeriod { get set }
        var selectedBarDate: Date? { get set }
        var isLoading: Bool { get }
        var errorMessage: String? { get }
        
        var chartData: [ChartDataPoint] { get }
        var summaryTitle: String { get }
        var summaryAmount: Double { get }
        var averageAmount: Double { get }
        var highestDay: Double { get }
        var lowestDay: Double { get }
        var groupedTransactions: [ExpenseGroup] { get }
        
        func barColor(for date: Date) -> Color
        
        @MainActor
        func loadExpenses()
    }
    
    @Observable
    final class ViewModelImpl: ViewModel {
        @ObservationIgnored
        private let repository: ExpensesRepositoryProtocol
        
        private var allExpenses: [ExpenseModel] = []
        
        var selectedPeriod: TimePeriod = .week
        var selectedBarDate: Date? = nil
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(repository: ExpensesRepositoryProtocol) {
            self.repository = repository
        }
        
        // MARK: - Data Loading
        
        @MainActor
        func loadExpenses() {
            isLoading = true
            errorMessage = nil
            
            do {
                allExpenses = try repository.fetchAll()
            } catch {
                errorMessage = "Failed to load expenses: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
        
        // MARK: - Chart Data
        
        var chartData: [ChartDataPoint] {
            let calendar = Calendar.current
            let range = selectedPeriod.dateRange
            let component = selectedPeriod.calendarComponent
            
            let filteredExpenses = allExpenses.filter {
                $0.date >= range.start && $0.date <= range.end
            }
            
            let grouped = Dictionary(grouping: filteredExpenses) { expense -> Date in
                bucketDate(for: expense.date, component: component, calendar: calendar)
            }
            
            var points: [ChartDataPoint] = []
            var current = bucketDate(for: range.start, component: component, calendar: calendar)
            let end = range.end
            
            while current <= end {
                let total = grouped[current]?.reduce(0) { $0 + $1.amount } ?? 0
                points.append(ChartDataPoint(date: current, total: total))
                
                guard let next = calendar.date(byAdding: component, value: 1, to: current) else { break }
                current = next
            }
            
            return points
        }
        
        // MARK: - Grouped Transactions
        
        var groupedTransactions: [ExpenseGroup] {
            let calendar = Calendar.current
            let range = selectedPeriod.dateRange
            
            let filtered = allExpenses
                .filter { $0.date >= range.start && $0.date <= range.end }
                .sorted { $0.date > $1.date }
            
            let grouped = Dictionary(grouping: filtered) { expense in
                calendar.startOfDay(for: expense.date)
            }
            
            return grouped
                .sorted { $0.key > $1.key }
                .map { date, expenses in
                    ExpenseGroup(
                        id: date,
                        label: date.relativeLabel,
                        items: expenses
                    )
                }
        }
        
        // MARK: - Helpers
        
        private func bucketDate(for date: Date, component: Calendar.Component, calendar: Calendar) -> Date {
            switch component {
            case .hour:
                return calendar.date(
                    from: calendar.dateComponents([.year, .month, .day, .hour], from: date)
                ) ?? date
            case .day:
                return calendar.startOfDay(for: date)
            case .weekOfYear:
                return calendar.date(
                    from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
                ) ?? date
            case .month:
                return calendar.date(
                    from: calendar.dateComponents([.year, .month], from: date)
                ) ?? date
            default:
                return calendar.startOfDay(for: date)
            }
        }
    }
    
    // MARK: - Mock ViewModel
    
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
            for dayOffset in 0..<30 {
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
                points.append(ChartDataPoint(date: current, total: total))
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

// MARK: - ViewModel Extension (Shared Implementation)
extension TransactionsHistoryView.ViewModel {
    var summaryTitle: String {
        if let selected = selectedBarDate {
            switch selectedPeriod {
            case .day:
                return selected.formatted(.dateTime.hour().minute())
            case .week, .month:
                return selected.formatted(.dateTime.month().day())
            case .sixMonths:
                return selected.formatted(.dateTime.month(.wide))
            case .year:
                return selected.formatted(.dateTime.year())
            }
        }
        return selectedPeriod.rangeLabel
    }
    
    var summaryAmount: Double {
        if let selected = selectedBarDate {
            return chartData.first { $0.date.matches(selected, by: selectedPeriod.calendarComponent) }?.total ?? 0
        }
        return chartData.reduce(0) { $0 + $1.total }
    }
    
    var averageAmount: Double {
        let nonZero = chartData.filter { $0.total > 0 }
        guard !nonZero.isEmpty else { return 0 }
        return nonZero.reduce(0) { $0 + $1.total } / Double(nonZero.count)
    }
    
    var highestDay: Double {
        chartData.max(by: { $0.total < $1.total })?.total ?? 0
    }
    
    var lowestDay: Double {
        let nonZero = chartData.filter { $0.total > 0 }
        return nonZero.min(by: { $0.total < $1.total })?.total ?? 0
    }
    
    func barColor(for date: Date) -> Color {
        if let selected = selectedBarDate {
            let isSelected = date.matches(selected, by: selectedPeriod.calendarComponent)
            return isSelected
                ? Color.orange
                : Color.orange.opacity(0.4)
        }
        return Color.orange
    }
}
