//
//  TimePeriod.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 21/4/26.
//

import Foundation

enum HistoryTimePeriod: String, CaseIterable {
    case day = "D"
    case week = "W"
    case month = "M"
    case year = "Y"
    
    var rangeLabel: String {
        switch self {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .day: return .hour
        case .week: return .day
        case .month: return .day
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
        case .year:
            start = calendar.date(byAdding: .month, value: -12, to: calendar.startOfDay(for: now)) ?? now
        }
        
        return (start, end)
    }
}
