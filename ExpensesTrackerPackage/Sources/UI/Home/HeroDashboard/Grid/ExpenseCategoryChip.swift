//
//  Chip.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 18/5/26.
//

import SwiftUI

struct ExpenseCategoryChip: View {
    let chipModel: HeroDashboardModel.ChipModel
    let isSelected: Bool
    let backgroundOpacity: Double
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                if !isSelected {
                    Circle()
                        .fill(chipModel.category.color)
                        .frame(width: 9, height: 9)
                }

                Text(chipModel.category.displayName)
                    .font(.footnote.bold())
                    .foregroundStyle(isSelected ? .white : .primary)
                    .lineLimit(1)
                    .padding(.leading, 4)

                Text(chipModel.amount.formatted(currency: Currency.kgs.rawValue.uppercased()))
                    .font(.footnote.bold())
                    .foregroundStyle(isSelected ? .white.opacity(0.75) : .secondary)
                    .lineLimit(1)

                if isSelected {
                    Image(systemName: "xmark")
                        .resizable()
                        .font(.caption2.bold())
                        .foregroundStyle(.primary)
                        .frame(width: 6, height: 6)
                        .padding(2)
                        .overlay(alignment: .center) {
                            Circle()
                                .fill(.foreground.opacity(0.45))
                                .frame(width: 12, height: 12)
                        }
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
        }
        .background(
            chipModel.category.color.opacity(backgroundOpacity),
            in: .capsule
        )
        .buttonStyle(.plain)
    }
}
