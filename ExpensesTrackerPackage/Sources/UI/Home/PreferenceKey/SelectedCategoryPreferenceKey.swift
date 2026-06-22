//
//  SelectedCategoryPreferenceKey.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import SwiftUI

struct SelectedCategoryPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CategoryModel? = nil
    static func reduce(value: inout CategoryModel?, nextValue: () -> CategoryModel?) {
        value = nextValue()
    }
}
