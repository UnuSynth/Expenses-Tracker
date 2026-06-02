//
//  CategorySelector.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 28/5/26.
//

import SwiftUI

struct CategorySelector: View {
    let categories: [ExpenseModel.Category]
    @Binding var selection: ExpenseModel.Category

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
    let category: ExpenseModel.Category
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
    @Previewable @State var selection: ExpenseModel.Category = .groceries
    CategorySelector(
        categories: ExpenseModel.Category.allCases,
        selection: $selection
    )
}
