//
//  View+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 23/6/26.
//

import SwiftUI

// fix for known navigationTitle() bug when using localized resources
// https://developer.apple.com/forums/thread/771133
struct LocalizedNavigationTitleModifier: ViewModifier {
    private let locale: Locale
    private let localizedTitleResource: LocalizedStringResource
    
    init(locale: Locale, resource: LocalizedStringResource) {
        self.locale = locale
        self.localizedTitleResource = resource
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(prepareLocalizedString())
    }
    
    private func prepareLocalizedString() -> String {
        .init(resource: localizedTitleResource, locale: locale)
    }
}

extension View {
    func localizedNavigationTitle(
        locale: Locale,
        resource: LocalizedStringResource
    ) -> some View {
        modifier(LocalizedNavigationTitleModifier(locale: locale, resource: resource))
    }
}
