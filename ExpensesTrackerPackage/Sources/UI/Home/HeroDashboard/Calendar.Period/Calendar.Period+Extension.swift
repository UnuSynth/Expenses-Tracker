//
//  Calendar.Period+Extension.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 15/5/26.
//

import Foundation

extension Calendar.Period {
    var systemImage: String {
        guard #available(iOS 26.0, *) else {
            return "calendar"
        }

        guard case .day = self else {
            return "calendar"
        }

        return "\(dates.start.formatted(.dateTime.day())).calendar"
    }
    
    var descriptionResource: LocalizedStringResource {
        switch self {
        case .day: .today
        case .week: .thisWeek
        case .month: .thisMonth
        case .year: .thisYear
        case .custom: .period
        }
    }
    
    func description(locale: Locale) -> String {
        .init(resource: descriptionResource, locale: locale)
    }

    func datesDescription(locale: Locale) -> String {
        switch self {
        case .day:
            return .init(resource: .today, locale: locale)
        case .month:
            return dates.start.formatted(.dateTime.month().locale(locale))
        case .week where !dates.start.matches(dates.end, by: .year),
                .custom where !dates.start.matches(dates.end, by: .year):
            return "\(dates.start.formatted(.dateTime.day().month().year().locale(locale))) - \(dates.end.formatted(.dateTime.day().month().year().locale(locale)))"
        default:
            return "\(dates.start.formatted(.dateTime.day().month().locale(locale))) - \(dates.end.formatted(.dateTime.day().month().year().locale(locale)))"
        }
    }
}
