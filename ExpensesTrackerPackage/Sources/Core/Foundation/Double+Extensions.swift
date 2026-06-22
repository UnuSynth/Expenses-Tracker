//
//  Double+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 20/6/26.
//

extension Double {
    var formattedDescription: String {
        if truncatingRemainder(dividingBy: 1) == 0 {
            return formatted(.number.precision(.fractionLength(0)).locale(.init(identifier: "en_US"))) // Double(25) -> "25"
        } else {
            return formatted(.number.precision(.fractionLength(2)).locale(.init(identifier: "en_US"))) // Double(25.5) -> "25.50"
        }
    }
}
