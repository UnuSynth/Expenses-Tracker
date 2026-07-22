//
//  CategoryModel+DisplayName.swift
//  ExpensesTrackerPackage
//

import Foundation

extension CategoryModel {
    /// Localized label for display. Built-in categories (with a `key`) resolve
    /// through the string catalog against `locale`; custom categories fall
    /// back to the raw, user-entered `name`.
    public func displayName(locale: Locale = .autoupdatingCurrent) -> String {
        guard let key, !key.isEmpty else { return name }
        return String(
            resource: LocalizedStringResource(
                String.LocalizationValue(key),
                table: "Localizable",
                bundle: .module
            ),
            locale: locale
        )
    }
}
