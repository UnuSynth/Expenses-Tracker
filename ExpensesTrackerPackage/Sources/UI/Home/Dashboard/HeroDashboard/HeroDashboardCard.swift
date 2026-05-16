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
    
    var cases: [Calendar.Period] { [.day, .week, .month, .year] }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.dateTitle.uppercased())
                    .font(.headline.bold())
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Menu {
                    Picker("", selection: $selectedPeriod) {
                        ForEach(cases, id: \.self) { period in
                            Text(period.description)
                        }
                    }
                    
                    Button("Custom period") {
                        showDateRangePicker = true
                    }
                } label: {
                    Button(selectedPeriod.datesDescription, systemImage: selectedPeriod.systemImage) { }
                        .padding(8)
                }
                .font(.headline)
                .foregroundStyle(.indigo)
                .glassEffect()
            }
            
            Text(model.total.formatted(currency: "USD"))
            
            SpendingProportionalBar(
                segments: model.categories.map { $0.toSpendingBarSegment() },
                total: model.total
            )
            .frame(height: 10)
        }
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
        dateTitle: "Today",
        total: 500,
        categories: [
            HeroDashboardModel.Category(
                total: 200,
                category: .groceries
            ),
            HeroDashboardModel.Category(
                total: 150,
                category: .lunch
            ),
            HeroDashboardModel.Category(
                total: 150,
                category: .clothes
            )
        ]
    )
    HeroDashboardCard(model: model)
        .padding(16)
}
