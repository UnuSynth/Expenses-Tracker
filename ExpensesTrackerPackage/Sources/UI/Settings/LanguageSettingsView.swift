//
//  LanguageSettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 6/22/26.
//

import SwiftUI

struct LanguageSettingsView: View {
    private let supportedLanguages: [(code: String, name: String)] = [
        ("en", "English"),
        ("ru", "Русский")
    ]

    @AppStorage(AppStorageKeys.languageCode.key) private var selectedCode: String = "en"
    @Environment(\.locale) private var locale

    var body: some View {
        List(supportedLanguages, id: \.code) { language in
            Button {
                selectedCode = language.code
            } label: {
                HStack {
                    Text(language.name)
                        .foregroundStyle(.primary)
                    Spacer()
                    if selectedCode == language.code {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.background.secondary)
        .localizedNavigationTitle(locale: locale, resource: .language)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        LanguageSettingsView()
    }
}
