//
//  SettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        CurrencySettingsView()
                    } label: {
                        Label("Currency", systemImage: "display")
                    }
                    
                    NavigationLink {
                        CategoriesSettingsView()
                    } label: {
                        Label("Categories", systemImage: "tag.fill")
                    }
                } header: {
                    Text("General")
                }
                
                Section {
                } header: {
                    Text("Appearance")
                }
                
                Section {
                } header: {
                    Text(.about)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
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

