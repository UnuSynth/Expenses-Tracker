//
//  TransactionsHistoryViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/4/26.
//

import Foundation
import SwiftUI

@MainActor
protocol HistoryViewModel: AnyObject, Observable {
    var selectedPeriod: HistoryTimePeriod { get set }
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
    
    @MainActor
    func loadExpenses()
}

// MARK: - ViewModel Extension (Shared Implementation)
extension HistoryViewModel {
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
    
    func isSameBarDateSelected(_ newDate: Date) -> Bool {
        guard let selectedDate = selectedBarDate else { return false }
        return newDate.matches(selectedDate, by: selectedPeriod.calendarComponent)
    }
}

@Observable
@MainActor
final class HistoryViewModelImpl: HistoryViewModel {
    @ObservationIgnored
    private let repository: ExpensesRepositoryProtocol
    
    private var allExpenses: [ExpenseModel] = []
    
    var selectedPeriod: HistoryTimePeriod = .week
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
