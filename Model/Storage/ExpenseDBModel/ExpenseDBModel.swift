//
//  ExpenseDTO.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 19/2/26.
//

import Foundation
import SwiftData

@Model
class ExpenseDBModel {
    var id: UUID = UUID()
    
    var date: Date
    var amount: Double
    var category: ExpenseModel.Category
    var notes: ExpenseModel.Notes?
    
    init(model: ExpenseModel) {
        self.date = model.date
        self.amount = model.amount
        self.category = model.category
        self.notes = model.notes
    }
    
    func toEntity() -> ExpenseModel {
        .init(
            date: date,
            amount: amount,
            category: category,
            notes: notes
        )
    }
}

extension ExpenseModel.Category: Codable { }

extension ExpenseModel.Notes: Codable {
    enum CodingKeys: String, CodingKey {
        case desc
        case image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let desc = try container.decodeIfPresent(String.self, forKey: .desc)
        let image = try container.decodeIfPresent(String.self, forKey: .image)
        self.init(desc: desc, image: image)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.desc, forKey: .desc)
        try container.encodeIfPresent(self.image, forKey: .image)
    }
}
