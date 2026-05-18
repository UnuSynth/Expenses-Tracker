//
//  Chip.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 18/5/26.
//

import SwiftUI

/// Wraps chips using `ZStack` + `alignmentGuide` from
/// https://stackoverflow.com/a/58876712 (variable-width rows that adapt to width).
@MainActor
struct ExpenseCategoryGrid: View {
    let chips: [HeroDashboardModel.ChipModel]

    var body: some View {
        GeometryReader { geometry in
            wrappedContent(in: geometry)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func wrappedContent(in geometry: GeometryProxy) -> some View {
        // Layout closures run synchronously on the main thread during SwiftUI's
        // layout pass, so @unchecked Sendable is safe here.
        final class LayoutState: @unchecked Sendable {
            var width: CGFloat = .zero
            var height: CGFloat = .zero
        }
        let state = LayoutState()
        let containerWidth = geometry.size.width

        return ZStack(alignment: .topLeading) {
            ForEach(chips) { chipModel in
                ExpenseCategoryChip(chipModel: chipModel)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dimensions in
                        if abs(state.width) + dimensions.width > containerWidth {
                            state.width = 0
                            state.height -= dimensions.height
                        }
                        let result = state.width
                        if chipModel.id == chips.last?.id {
                            state.width = 0
                        } else {
                            state.width -= dimensions.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = state.height
                        if chipModel.id == chips.last?.id {
                            state.height = 0
                        }
                        return result
                    })
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
                .frame(width: 10, height: 10)

            Text(chipModel.category.displayName)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(chipModel.total.formatted(currency: "USD"))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(8)
        .background(chipModel.category.color.opacity(0.05), in: Capsule())
    }
}

#Preview {
    ExpenseCategoryGrid(
        chips: [
            .init(total: 100, category: .clothes),
            .init(total: 150, category: .groceries),
            .init(total: 200, category: .lunch),
            .init(total: 250, category: .sport),
            .init(total: 250, category: .sport),
            .init(total: 250, category: .sport),
            .init(total: 250, category: .sport),
        ]
    )
}
