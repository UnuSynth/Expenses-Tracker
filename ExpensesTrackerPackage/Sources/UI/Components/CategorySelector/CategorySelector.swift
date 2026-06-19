//
//  CategorySelector.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 28/5/26.
//

import SwiftUI

struct CategorySelector: View {
    let categories: [CategoryModel]
    @Binding var selection: CategoryModel?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories) { category in
                    CategorySelectorItem(
                        category: category,
                        isSelected: selection == category
                    )
                    .onTapGesture {
                        withAnimation(.interactiveSpring) {
                            selection = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

private struct CategorySelectorItem: View {
    let category: CategoryModel
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                isSelected ? category.color : Color.clear,
                                lineWidth: 2
                            )
                    }

                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(category.color)
            }

            Text(category.displayName)
                .font(.caption)
                .foregroundStyle(isSelected ? category.color : .secondary)
                .lineLimit(1)
        }
    }
}

#Preview {
    @Previewable @State var selection: CategoryModel? = nil
    let categories: [CategoryModel] = [
        CategoryModel(name: "groceries", displayName: "Groceries", icon: "cart.fill", color: .green),
        CategoryModel(name: "lunch", displayName: "Lunch", icon: "fork.knife", color: .orange),
        CategoryModel(name: "transport", displayName: "Transport", icon: "car.fill", color: .blue),
    ]
    CategorySelector(
        categories: categories,
        selection: $selection
    )
}
