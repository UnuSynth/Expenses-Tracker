//
//  Date+Extension.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/4/26.
//

import Foundation

extension Date {
    func isSameDay(as other: Date?) -> Bool {
        guard let other else { return false }
        return Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    var relativeLabel: String {
        if Calendar.current.isDateInToday(self) { return "Today" }
        if Calendar.current.isDateInYesterday(self) { return "Yesterday" }
        return self.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
    
    /// Compares two dates based on the specified calendar component
    /// - Parameters:
    ///   - other: The date to compare with
    ///   - component: The calendar component to use for comparison
    /// - Returns: True if dates match for the given component, false otherwise
    func matches(_ other: Date, by component: Calendar.Component) -> Bool {
        let calendar = Calendar.current
        
        switch component {
        case .hour:
            return calendar.dateComponents([.year, .month, .day, .hour], from: self)
                == calendar.dateComponents([.year, .month, .day, .hour], from: other)
        case .day:
            return self.isSameDay(as: other)
        case .weekOfYear:
            return calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
                == calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: other)
        case .month:
            return calendar.dateComponents([.year, .month], from: self)
                == calendar.dateComponents([.year, .month], from: other)
        default:
            return calendar.startOfDay(for: self) == calendar.startOfDay(for: other)
        }
    }
}
