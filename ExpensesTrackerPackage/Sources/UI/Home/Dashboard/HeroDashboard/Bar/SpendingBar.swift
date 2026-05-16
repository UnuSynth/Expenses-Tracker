//
//  SpendingBar.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/5/26.
//

import Foundation
import SwiftUI

struct SpendingBarSegment: Identifiable {
    let id = UUID()
    let color: Color
    let value: Double
}

struct SpendingProportionalBar: View {
    private let segments: [SpendingBarSegment]
    private let total: Double
    
    private let gap: Double = 2
    private var totalGap: Double {
        gap * Double(segments.count - 1)
    }
    
    init(segments: [SpendingBarSegment], total: Double) {
        self.segments = segments
        self.total = total
    }
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - totalGap
            let cornerRadius = geo.size.height / 2
            
            HStack(spacing: gap) {
                ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                    let width = availableWidth * (segment.value / total)
                    let isFirst = index == 0
                    let isLast = index == segments.count - 1
                    
                    ZStack {
                        if isFirst {
                            // Round left corners only
                            UnevenRoundedRectangle(
                                topLeadingRadius: cornerRadius,
                                bottomLeadingRadius: cornerRadius
                            )
                            .fill(segment.color)
                        } else if isLast {
                            // Round right corners only
                            UnevenRoundedRectangle(
                                bottomTrailingRadius: cornerRadius,
                                topTrailingRadius: cornerRadius
                            )
                            .fill(segment.color)
                        } else {
                            // No rounding for middle segments
                            Rectangle()
                                .fill(segment.color)
                        }
                    }
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
        SpendingBarSegment(color: .red, value: 1),
        SpendingBarSegment(color: .orange, value: 2),
        SpendingBarSegment(color: .yellow, value: 1),
        SpendingBarSegment(color: .green, value: 2),
        SpendingBarSegment(color: .blue, value: 1)
    ]
    let total = segments.reduce(0) { $0 + $1.value }
    SpendingProportionalBar(segments: segments, total: total)
        .frame(height: 16)
        .padding(16)
}
