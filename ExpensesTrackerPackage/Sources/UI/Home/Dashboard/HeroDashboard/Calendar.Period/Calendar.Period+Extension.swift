//
//  Calendar.Period+Extension.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 15/5/26.
//

import Foundation

extension Calendar.Period {
    var systemImage: String {
        guard case .day = self else {
            return "calendar"
        }

        return "\(dates.start.formatted(.dateTime.day())).calendar"
    }

    var description: String {
        switch self {
        case .day:
            "Today"
        case .week:
            "This week"
        case .month:
            "This month"
        case .year:
            "This year"
        case .custom:
            "Custom period"
        }
    }

    var datesDescription: String {
        switch self {
        case .day:
            return "Today"
        case .month:
            return dates.start.formatted(.dateTime.month())
        case .week, .custom:
            guard !dates.start.matches(dates.end, by: .year) else { fallthrough }
            return "\(dates.start.formatted(.dateTime.day().month().year())) - \(dates.end.formatted(.dateTime.day().month().year()))"
        default:
            return "\(dates.start.formatted(.dateTime.day().month())) - \(dates.end.formatted(.dateTime.day().month().year()))"
        }
    }
}
