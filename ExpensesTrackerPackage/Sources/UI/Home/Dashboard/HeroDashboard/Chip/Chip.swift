//
//  Chip.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 18/5/26.
//

import SwiftUI

private struct WrappedHStackLayout: Layout {
    var hSpacing: CGFloat = 6
    var vSpacing: CGFloat = 5

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

@MainActor
struct ExpenseCategoryGrid: View {
    let chips: [HeroDashboardModel.ChipModel]

    var body: some View {
        WrappedHStackLayout(hSpacing: 6, vSpacing: 5) {
            ForEach(chips) { chipModel in
                ExpenseCategoryChip(chipModel: chipModel)
            }
        }
    }
}

struct ExpenseCategoryChip: View {
    let chipModel: HeroDashboardModel.ChipModel

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(chipModel.category.color)
                .frame(width: 9, height: 9)

            Text(chipModel.category.displayName)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(chipModel.amount.formatted(currency: "USD"))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(8)
        .background(chipModel.category.color.opacity(0.05), in: .capsule)
    }
}

#Preview {
    ExpenseCategoryGrid(
        chips: [
            .init(amount: 100, category: .clothes),
            .init(amount: 150, category: .groceries),
            .init(amount: 200, category: .lunch),
            .init(amount: 250, category: .sport),
            .init(amount: 250, category: .sport),
            .init(amount: 250, category: .sport),
            .init(amount: 250, category: .sport),
        ]
    )
    .padding()
}
