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
                start = calendar.date(byAdding: .month, value: -12, to: calendar.startOfDay(for: now)) ?? now
            }
            
            return (start, end)
        }
    }
    
    struct ChartDataPoint: Identifiable {
        let id: UUID = .init()
        let dateStart: Date
        let dateEnd: Date
        let total: Double
    }
    
    struct ExpenseGroup: Identifiable {
        let id: Date
        let label: String
        let items: [ExpenseModel]
    }
    
    @MainActor
    protocol ViewModel: AnyObject, Observable {
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
    @MainActor
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
                points.append(ChartDataPoint(dateStart: current, dateEnd: end, total: total))
                
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
}

// MARK: - ViewModel Extension (Shared Implementation)
extension TransactionsHistoryView.ViewModel {
    var summaryTitle: String {
        if let selected = selectedBarDate,
           let end = chartData.first(where: { $0.dateStart.matches(selected, by: selectedPeriod.calendarComponent) })?.dateEnd {
            switch selectedPeriod {
            case .day:
                return "\(selected.formatted(.dateTime.day().month())), \(selected.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)))) - \(end.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated))))"
            case .week, .month:
                return selected.formatted(.dateTime.day().month().year())
            case .sixMonths:
                return "\(selected.formatted(.dateTime.day())) - \(end.formatted(.dateTime.day().month().year()))"
            case .year:
                return selected.formatted(.dateTime.month().year())
            }
        }
        return selectedPeriod.rangeLabel
    }
    
    var summaryAmount: Double {
        if let selected = selectedBarDate {
            return chartData.first { $0.dateStart.matches(selected, by: selectedPeriod.calendarComponent) }?.total ?? 0
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
