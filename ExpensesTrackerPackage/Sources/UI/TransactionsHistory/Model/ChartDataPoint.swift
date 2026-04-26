//
//  ChartDataPoint.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 21/4/26.
//

import Foundation

struct ChartDataPoint: Identifiable {
    let id: UUID = .init()
    let dateStart: Date
    let dateEnd: Date
    let total: Double
}
