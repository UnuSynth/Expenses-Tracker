//
//  ExpensesTrackerSchemaV2.swift
//  ExpensesTrackerPackage
//

import Foundation
import SwiftData

enum ExpensesTrackerSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [ExpenseDBModel.self, CategoryModel.self] }
}
