//
//  CategoriesSettingsView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 4/6/26.
//

import SwiftUI
import SwiftData

struct CategoriesSettingsView: View {
    @Query(sort: \CategoryModel.sortOrder) private var categories: [CategoryModel]
    @Environment(\.modelContext) private var context

    @State private var isAddingCategory = false

    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink {
                    Text(category.name)
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
                        Text(category.name)
                        Spacer()
                        Text(.count(countForCategory(category)))
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .onDelete { indices in
                indices.forEach { deleteCategory(categories[$0]) }
            }
            .onMove { source, destination in
                var reordered = categories
                reordered.move(fromOffsets: source, toOffset: destination)
                for (index, category) in reordered.enumerated() {
                    category.sortOrder = index
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(.background.secondary)
        .navigationTitle(.categories)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    EditButton()
                    Button {
                        isAddingCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingCategory) {
            AddCategoryView(nextSortOrder: (categories.last?.sortOrder ?? -1) + 1)
        }
    }

    private func deleteCategory(_ category: CategoryModel) {
        context.delete(category)
    }

    private func countForCategory(_ category: CategoryModel) -> Int {
        let categoryName = category.name
        let descriptor = FetchDescriptor<ExpenseDBModel>(
            predicate: #Predicate { $0.category.name == categoryName }
        )
        return (try? context.fetchCount(descriptor)) ?? 0
    }
}

#Preview {
    NavigationStack {
        CategoriesSettingsView()
    }
}
