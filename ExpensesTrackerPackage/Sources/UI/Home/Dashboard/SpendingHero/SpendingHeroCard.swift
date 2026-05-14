//
//  HomeViewExpensesTodayCell.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 16/2/26.
//

import SwiftUI

struct SpendingHeroCard: View {
    private let model: SpendingHeroModel

    private var progress: Double {
        guard model.average > 0 else { return 0 }
        return min(model.total / model.average, 1.0)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                Text("This Month")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer().frame(height: 4)

                Text(model.total.formatted(currency: model.currency))
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .accessibilityValue(
                        "\(Int(model.total)) \(Locale.current.localizedString(forCurrencyCode: model.currency) ?? model.currency)"
                    )

                Text("\(model.currency)  ·  \(Date.now.formatted(.dateTime.month(.wide).year()))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Divider().padding(.vertical, 12)

                ProgressView(value: progress)
                    .tint(.accentColor)
                    .animation(.easeInOut(duration: 0.3), value: progress)

                Spacer().frame(height: 8)

                if model.average > 0 {
                    Text(
                        "\(Int(progress * 100))% of 30-day average (\(model.average.formatted(currency: model.currency)))"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                if let partnerTotal = model.partnerTotal {
                    HStack(spacing: 6) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                        Text("Partner · \(partnerTotal, format: .currency(code: model.currency).presentation(.narrow))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))

            // Progress ring
            ProgressRing(progress: progress)
                .frame(width: 40, height: 40)
                .padding(20)
        }
    }
    
    init(model: SpendingHeroModel) {
        self.model = model
    }
}

struct ProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemFill), lineWidth: 3)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}
