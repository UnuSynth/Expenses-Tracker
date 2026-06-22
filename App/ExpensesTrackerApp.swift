//
//  Expenses_TrackerApp.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI
import SwiftData
import ExpensesTrackerPackage

@main
struct ExpensesTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ExpensesTrackerViewer()
        }
        .modelContainer(for: [ExpenseDBModel.self, CategoryModel.self]) { result in
            guard case .success(let modelContainer) = result else {
                return
            }
            
            BuiltinCategoriesSeeder.seed(into: modelContainer.mainContext)
            ExpensesSeeder.seed(into: modelContainer.mainContext)
        }
    }
}
