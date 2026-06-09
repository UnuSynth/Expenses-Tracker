//
//  CategoriesSettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI

struct CategoriesSettingsView: View {
    @State private var viewModel: CategoriesSettingsViewModel

    init(viewModel: CategoriesSettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.categories) { category in
                NavigationLink {
                    Text(category.displayName)
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(category.color)
                                .frame(width: 32, height: 32)
                            Image(systemName: category.icon)
                                .foregroundStyle(.white)
                                .font(.system(size: 15))
                        }
                        Text(category.displayName)
                        Spacer()
                        Text("\(viewModel.countForCategory(category))")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .onDelete { indices in
                viewModel.deleteCategories(at: indices)
            }
            .onMove { source, destination in
                viewModel.moveCategories(from: source, to: destination)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.background.secondary)
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    EditButton()
                    Button {
                        // TODO: Add category
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesSettingsView(viewModel: CategoriesSettingsViewModelMock())
    }
}
