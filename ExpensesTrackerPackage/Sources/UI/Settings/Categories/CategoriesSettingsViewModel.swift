//
//  CategoriesSettingsViewModel.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 9/6/26.
//

import Foundation

@MainActor
protocol CategoriesSettingsViewModel: AnyObject, Observable {
    var categories: [ExpenseModel.Category] { get }

    func countForCategory(_ category: ExpenseModel.Category) -> Int
    func deleteCategories(at offsets: IndexSet)
    func moveCategories(from source: IndexSet, to destination: Int)
}
