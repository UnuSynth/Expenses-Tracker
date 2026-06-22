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
    @State private var selectedCategory: CategoryModel?
    @AppStorage("selectedCurrency") private var selectedCurrencyRaw: String = Currency.usd.rawValue
    
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
                    Label(selectedCategory.name.uppercased(), systemImage: selectedCategory.icon)
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
                    currency: .initialize(rawValue: selectedCurrencyRaw)
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
        .onChange(of: model) { _, newValue in
            let hasChangesInCategories = !newValue.chips.contains { $0.category == selectedCategory }
            
            if hasChangesInCategories {
                selectedCategory = nil
            }
        }
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
    func onCategorySelect(action: @escaping (CategoryModel?) -> Void) -> some View {
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
                category: CategoryModel(name: "Groceries", icon: "cart.fill", color: .green)
            ),
            HeroDashboardModel.ChipModel(
                amount: 150,
                category: CategoryModel(name: "Lunch", icon: "fork.knife", color: .orange)
            ),
            HeroDashboardModel.ChipModel(
                amount: 150,
                category: CategoryModel(name: "Clothes", icon: "tshirt.fill", color: .purple)
            )
        ]
    )
    HeroDashboardCard(
        selectedPeriod: $selectedPeriod,
        model: model
    )
        .padding(16)
}
