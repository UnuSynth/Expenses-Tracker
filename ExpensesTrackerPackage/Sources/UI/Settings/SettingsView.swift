//
//  SettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.locale) private var locale
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        CurrencySettingsView()
                    } label: {
                        Label { Text(.currency) } icon: { Image(systemName: "display") }
                    }

                    NavigationLink {
                        CategoriesSettingsView()
                    } label: {
                        Label { Text(.categories) } icon: { Image(systemName: "tag.fill") }
                    }

                    NavigationLink {
                        LanguageSettingsView()
                    } label: {
                        Label { Text(.language) } icon: { Image(systemName: "globe") }
                    }
                } header: {
                    Text(.general)
                }

                Section {
                } header: {
                    Text(.appearance)
                }
                
                Section {
                } header: {
                    Text(.about)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .localizedNavigationTitle(locale: locale, resource: .settings)
            .navigationBarTitleDisplayMode(.large)
            .background(.background.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

