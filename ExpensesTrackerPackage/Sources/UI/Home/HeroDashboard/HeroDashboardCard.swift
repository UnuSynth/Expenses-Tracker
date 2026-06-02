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
    @Binding private var selectedPeriod: Calendar.Period
    @State private var selectedCategory: ExpenseModel.Category?
    
    var availablePickerPeriods: [Calendar.Period] { [.day, .week, .month, .year] }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            content
                .background(
                    .white,
                    in: ConcentricRectangle(corners: .concentric(minimum: 24))
                )
        } else {
            content
                .background(
                    .white,
                    in: RoundedRectangle(cornerRadius: 24)
                )
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let selectedCategory {
                    Label(selectedCategory.displayName.uppercased(), systemImage: selectedCategory.icon)
                        .font(.footnote.bold())
                        .foregroundStyle(selectedCategory.color)
                        .lineLimit(1)
                        .truncationMode(.middle)
                } else {
                    Text(selectedPeriod.description.uppercased())
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                if #available(iOS 26.0, *) {
                    upperMenu
                        .glassEffect()
                } else {
                    upperMenu
                }
            }
            
            TotalMoney(
                money: .init(
                    amount: model.chips.first { $0.category == selectedCategory }?.amount ?? model.total,
                    currency: .current
                )
            )
            .contentTransition(.numericText())
            
            SpendingProportionalBar(
                segments: model.chips.map { $0.toSpendingBarSegment() },
                total: model.total,
                selectedIndex: model.chips.firstIndex(where: { $0.category == selectedCategory })
            )
            .frame(height: 10)
            
            ExpenseCategoryGrid(chips: model.chips)
                .onCategorySelect { category in
                    selectedCategory = category
                }
                .padding(.top, 8)
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
        .preference(key: SelectedCategoryPreferenceKey.self, value: selectedCategory)
        .animation(.easeInOut(duration: 0.3), value: selectedCategory)
    }
    
    private var upperMenu: some View {
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
        .font(.footnote.weight(.medium))
        .foregroundStyle(.indigo)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.indigo.opacity(0.15), in: .capsule)
        .fixedSize(horizontal: true, vertical: false)
    }
    
    init(selectedPeriod: Binding<Calendar.Period>, model: HeroDashboardModel) {
        self._selectedPeriod = selectedPeriod
        self.model = model
    }
}

extension HeroDashboardCard {
    func onCategorySelect(action: @escaping (ExpenseModel.Category?) -> Void) -> some View {
        onPreferenceChange(SelectedCategoryPreferenceKey.self) { category in
            action(category)
        }
    }
}

#Preview {
    @Previewable @State var selectedPeriod: Calendar.Period = .day
    
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
    HeroDashboardCard(
        selectedPeriod: $selectedPeriod,
        model: model
    )
        .padding(16)
}
