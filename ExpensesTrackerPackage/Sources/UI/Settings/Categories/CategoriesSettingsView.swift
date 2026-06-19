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

    var body: some View {
        List {
            ForEach(categories) { category in
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
                        Text("\(countForCategory(category))")
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
