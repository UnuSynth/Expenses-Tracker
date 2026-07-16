//
//  SelectedCurrency.swift
//  ExpensesTrackerPackage
//

import SwiftUI

/// Reads/writes the app's selected `Currency` from `AppStorage`, collapsing the
/// repeated `@AppStorage(AppStorageKeys.currency.key)` + `.initialize(rawValue:)` pair
/// that used to live in every view touching currency.
@propertyWrapper
struct SelectedCurrency: DynamicProperty {
    @AppStorage(AppStorageKeys.currency.key) private var raw: String = Currency.usd.rawValue

    var wrappedValue: Currency {
        get { .initialize(rawValue: raw) }
        nonmutating set { raw = newValue.rawValue }
    }

    var projectedValue: Binding<Currency> {
        Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}
