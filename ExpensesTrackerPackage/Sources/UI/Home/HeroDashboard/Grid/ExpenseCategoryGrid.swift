//
//  ExpenseCategoryGrid.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import SwiftUI

@MainActor
struct ExpenseCategoryGrid: View {
    let chips: [HeroDashboardModel.ChipModel]
    @State private var selectedCategory: CategoryModel?
    @State private var isExpanded = false

    private let collapsedLimit = UIApplication.screenHeight > 667 ? 3 : 1

    private var needsToggle: Bool {
        chips.count > collapsedLimit
    }

    private var visibleChips: [HeroDashboardModel.ChipModel] {
        guard needsToggle, !isExpanded else { return chips }
        return Array(chips.prefix(collapsedLimit))
    }

    var body: some View {
        WrappedHStackLayout(hSpacing: 6, vSpacing: 5) {
            ForEach(visibleChips) { chipModel in
                ExpenseCategoryChip(
                    chipModel: chipModel,
                    isSelected: selectedCategory == chipModel.category,
                    backgroundOpacity: backgroundOpacity(for: chipModel.category),
                    onTap: {
                        toggleSelection(chipModel.category)
                    }
                )
            }

            if needsToggle {
                expandToggleChip
            }
        }
        .preference(key: SelectedCategoryPreferenceKey.self, value: selectedCategory)
        .animation(.default, value: chips)
    }

    private var expandToggleChip: some View {
        let hiddenCount = chips.count - collapsedLimit
        let label = isExpanded ? "Show less" : "+\(hiddenCount) more"
        return Button {
            if isExpanded, let selected = selectedCategory,
               !Array(chips.prefix(collapsedLimit)).contains(where: { $0.category == selected }) {
                selectedCategory = nil
            }
            isExpanded.toggle()
        } label: {
            Text(label)
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
        }
        .background(.secondary.opacity(0.1), in: .capsule)
        .buttonStyle(.plain)
    }

    private func toggleSelection(_ category: CategoryModel) {
        selectedCategory = selectedCategory == category ? nil : category
    }

    private func backgroundOpacity(for category: CategoryModel) -> Double {
        guard let selected = selectedCategory else { return 0.15 }
        return category == selected ? 0.8 : 0.05
    }
}

extension ExpenseCategoryGrid {
    func onCategorySelect(action: @escaping (CategoryModel?) -> Void) -> some View {
        onPreferenceChange(SelectedCategoryPreferenceKey.self) { category in
            action(category)
        }
    }
}

fileprivate struct WrappedHStackLayout: Layout {
    var hSpacing: CGFloat = 4
    var vSpacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? .infinity
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > containerWidth, currentRowWidth > 0 {
                totalHeight += currentRowHeight + vSpacing
                currentRowWidth = 0
                currentRowHeight = 0
            }
            currentRowWidth += size.width + hSpacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        totalHeight += currentRowHeight
        return CGSize(width: containerWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var currentRowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += currentRowHeight + vSpacing
                x = bounds.minX
                currentRowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + hSpacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

#Preview {
    ExpenseCategoryGrid(
        chips: [
            .init(amount: 100, category: CategoryModel(name: "Clothes", icon: "tshirt.fill", color: .purple)),
            .init(amount: 150, category: CategoryModel(name: "Groceries", icon: "cart.fill", color: .green)),
            .init(amount: 200, category: CategoryModel(name: "Lunch", icon: "fork.knife", color: .orange)),
            .init(amount: 250, category: CategoryModel(name: "Sport", icon: "figure.run", color: .indigo)),
            .init(amount: 80, category: CategoryModel(name: "Transport", icon: "car.fill", color: .blue)),
            .init(amount: 120, category: CategoryModel(name: "Entertainment", icon: "popcorn.fill", color: .purple)),
        ]
    )
    .padding()
}
