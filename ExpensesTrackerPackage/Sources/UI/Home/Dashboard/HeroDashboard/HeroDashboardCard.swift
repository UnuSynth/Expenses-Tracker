//
//  HomeViewExpensesTodayCell.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 16/2/26.
//

import SwiftUI

struct HeroDashboardCard: View {
    private let model: HeroDashboardModel
    
    @State private var showDateRangePicker = false
    @State private var selectedPeriod: Calendar.Period = .day
    
    var availablePickerPeriods: [Calendar.Period] { [.day, .week, .month, .year] }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(selectedPeriod.description.uppercased())
                    .font(.headline.bold())
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Menu {
                    Picker("", selection: $selectedPeriod) {
                        ForEach(availablePickerPeriods, id: \.self) { period in
                            Text(period.description)
                        }
                    }
                    
                    Button("Custom period") {
                        showDateRangePicker = true
                    }
                } label: {
                    Button(selectedPeriod.datesDescription, systemImage: selectedPeriod.systemImage) { }
                }
                .font(.callout.weight(.medium))
                .foregroundStyle(.indigo)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.indigo.opacity(0.15), in: .capsule)
                .glassEffect()
            }
            
            TotalMoney(
                money: .init(
                    amount: model.total,
                    currency: .usd
                )
            )
            
            SpendingProportionalBar(
                segments: model.chips.map { $0.toSpendingBarSegment() },
                total: model.total
            )
            .frame(height: 10)
            
            ExpenseCategoryGrid(chips: model.chips)
        }
        .padding(16)
        .sheet(isPresented: $showDateRangePicker) {
            DateRangePicker(
                selectedPeriod: $selectedPeriod,
                startDate: selectedPeriod.dates.start,
                endDate: selectedPeriod.dates.end,
                bounds: Date.now.addingTimeInterval(-60*60*24*365*2)..<Date.now
            )
            .presentationDetents([.medium])
        }
    }
    
    init(model: HeroDashboardModel) {
        self.model = model
    }
}

#Preview {
    let model = HeroDashboardModel(
        chips: [
            HeroDashboardModel.ChipModel(
                amount: 200,
                category: .groceries
            ),
            HeroDashboardModel.ChipModel(
                amount: 150,
                category: .lunch
            ),
            HeroDashboardModel.ChipModel(
                amount: 150,
                category: .clothes
            )
        ]
    )
    HeroDashboardCard(model: model)
        .padding(16)
}
