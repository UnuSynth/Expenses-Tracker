//
//  SpendingBar.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/5/26.
//

import Foundation
import SwiftUI

struct SpendingBarSegment: Identifiable {
    let id: String
    let color: Color
    let value: Double
}

struct SpendingProportionalBar: View {
    private let segments: [SpendingBarSegment]
    private let total: Double
    private let selectedIndex: Int?

    private let gap: Double = 1
    private var totalGap: Double {
        gap * Double(segments.count - 1)
    }

    init(segments: [SpendingBarSegment], total: Double, selectedIndex: Int? = nil) {
        self.segments = segments
        self.total = total
        self.selectedIndex = selectedIndex
    }

    var body: some View {
        GeometryReader { geo in
            let availableWidth = max(0, geo.size.width - totalGap)
            let cornerRadius = geo.size.height / 2

            HStack(spacing: gap) {
                ForEach(segments) { segment in
                    let width = total > 0 ? availableWidth * (segment.value / total) : 0
                    let index = segments.firstIndex(where: { $0.id == segment.id }) ?? 0
                    let isFirst = index == 0
                    let isLast = index == segments.count - 1
                    let opacity: Double = selectedIndex == nil || selectedIndex == index ? 1 : 0.25

                    ZStack {
                        if isFirst, isLast {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(segment.color)
                        } else if isFirst {
                            UnevenRoundedRectangle(
                                topLeadingRadius: cornerRadius,
                                bottomLeadingRadius: cornerRadius
                            )
                            .fill(segment.color)
                        } else if isLast {
                            UnevenRoundedRectangle(
                                bottomTrailingRadius: cornerRadius,
                                topTrailingRadius: cornerRadius
                            )
                            .fill(segment.color)
                        } else {
                            Rectangle()
                                .fill(segment.color)
                        }
                    }
                    .opacity(opacity)
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                    .frame(
                        width: width,
                        height: geo.size.height
                    )
                }
            }
        }
    }
}

#Preview {
    let segments = [
        SpendingBarSegment(id: "red", color: .red, value: 1),
        SpendingBarSegment(id: "orange", color: .orange, value: 2),
        SpendingBarSegment(id: "yellow", color: .yellow, value: 1),
        SpendingBarSegment(id: "green", color: .green, value: 2),
        SpendingBarSegment(id: "blue", color: .blue, value: 1)
    ]
    let total = segments.reduce(0) { $0 + $1.value }
    SpendingProportionalBar(segments: segments, total: total)
        .frame(height: 16)
        .padding(16)
}
