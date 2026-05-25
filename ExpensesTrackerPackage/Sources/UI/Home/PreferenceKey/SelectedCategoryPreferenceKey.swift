//
//  SelectedCategoryPreferenceKey.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import SwiftUI

struct SelectedCategoryPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: ExpenseModel.Category? = nil
    static func reduce(value: inout ExpenseModel.Category?, nextValue: () -> ExpenseModel.Category?) {
        value = nextValue()
    }
}
