//
//  Date+Extension.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 18/2/26.
//

import Foundation

extension Calendar {
    enum Period {
        case day
        case week
        case month
        case year
        case custom(start: Date, end: Date)
        
        var dates: (start: Date, end: Date) {
            let endOfToday = Calendar.current.endOfDay(for: .now)
            
            switch self {
            case .day:
                let startOfDay = Calendar.current.startOfDay(for: .now)
                return (startOfDay, endOfToday)
            case .week:
                let startOfWeek = Calendar.current.date(
                    from: Calendar.current.dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: .now
                    )
                ) ?? .now // it will never be nil
                return (startOfWeek, endOfToday)
            case .month:
                let startOfMonth = Calendar.current.date(
                    from: Calendar.current.dateComponents(
                        [.year, .month],
                        from: .now
                    )
                ) ?? .now // it will never be nil
                return (startOfMonth, endOfToday)
            case .year:
                let startOfYear = Calendar.current.date(
                    from: Calendar.current.dateComponents(
                        [.year],
                        from: .now
                    )
                ) ?? .now // it will never be nil
                return (startOfYear, .now)
            case .custom(let start, let end):
                return (start, end)
            }
        }
    }
    
    func endOfDay(for date: Date) -> Date {
        dateInterval(of: .day, for: date)?.end ?? date
    }
}
