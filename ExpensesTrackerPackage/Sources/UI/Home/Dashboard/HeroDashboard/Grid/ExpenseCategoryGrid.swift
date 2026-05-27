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
    @State private var selectedCategory: ExpenseModel.Category?
    @State private var isExpanded = false

    private let collapsedLimit = 4

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
                        withAnimation {
                            toggleSelection(chipModel.category)
                        }
                    }
                )
            }

            if needsToggle {
                expandToggleChip
            }
        }
        .preference(key: SelectedCategoryPreferenceKey.self, value: selectedCategory)
    }

    private var expandToggleChip: some View {
        let hiddenCount = chips.count - collapsedLimit
        let label = isExpanded ? "Show less" : "+\(hiddenCount) more"
        return Button {
            withAnimation(.spring(duration: 0.3)) {
                if isExpanded == true, let selected = selectedCategory,
                   !Array(chips.prefix(collapsedLimit)).contains(where: { $0.category == selected }) {
                    selectedCategory = nil
                }
                isExpanded.toggle()
            }
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

    private func toggleSelection(_ category: ExpenseModel.Category) {
        selectedCategory = selectedCategory == category ? nil : category
    }

    private func backgroundOpacity(for category: ExpenseModel.Category) -> Double {
        guard let selected = selectedCategory else { return 0.15 }
        return category == selected ? 0.8 : 0.05
    }
}

extension ExpenseCategoryGrid {
    func onCategorySelect(action: @escaping (ExpenseModel.Category?) -> Void) -> some View {
        self.onPreferenceChange(SelectedCategoryPreferenceKey.self) { category in
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
            .init(amount: 100, category: .clothes),
            .init(amount: 150, category: .groceries),
            .init(amount: 200, category: .lunch),
            .init(amount: 250, category: .sport),
            .init(amount: 80, category: .transport),
            .init(amount: 120, category: .entertainment),
        ]
    )
    .padding()
}
