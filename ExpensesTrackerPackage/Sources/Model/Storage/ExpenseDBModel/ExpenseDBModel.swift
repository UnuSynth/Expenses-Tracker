//
//  ExpenseDTO.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 19/2/26.
//

import Foundation
import SwiftData

@Model
public class ExpenseDBModel {
    public var id: UUID = UUID()

    var date: Date
    var amount: Double
    var category: CategoryModel
    var notes: Notes?

    init(
        date: Date,
        amount: Double,
        category: CategoryModel,
        notes: Notes? = nil
    ) {
        self.date = date
        self.amount = amount
        self.category = category
        self.notes = notes
    }
}

extension ExpenseDBModel {
    struct Notes: Codable {
        let desc: String?
        let image: String?

        init(desc: String? = nil, image: String? = nil) {
            self.desc = desc
            self.image = image
        }
    }
}
