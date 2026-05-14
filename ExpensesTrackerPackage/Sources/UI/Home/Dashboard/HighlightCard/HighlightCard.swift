//
//  HighlightCard.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 26/4/26.
//

import SwiftUI

struct HighlightCard: View {
    let icon: String
    let iconColor: Color
    let headline: String
    let value: String
    let sub: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)

            Spacer()

            Text(headline)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3)
                .bold()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(sub)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(width: 160, height: 120, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))
    }
}
