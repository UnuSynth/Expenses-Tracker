//
//  HomeViewExpensesTodayCell.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 16/2/26.
//

import SwiftUI

private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat { a + (b - a) * t }

struct HeroDashboardCard: View {
    private let model: HeroDashboardModel
    private let selectedCategory: CategoryModel?
    private let onSelect: (CategoryModel?) -> Void
    let progress: CGFloat

    @State private var showDateRangePicker = false
    @Binding private var selectedPeriod: Calendar.Period
    @Environment(\.locale) private var locale

    private var money: Money { model.money(for: selectedCategory) }
    private var selectedIndex: Int? { model.chips.firstIndex { $0.category == selectedCategory } }

    @State private var headerHeight: CGFloat = 0
    @State private var upperMenuFrame: CGRect = .zero

    private let cardPadding: CGFloat = 16
    // At full collapse TotalMoney renders at ~31pt (48pt × 0.55), matching the capsule row height
    private let collapsedScale: CGFloat = 0.55

    var availablePickerPeriods: [Calendar.Period] { [.day, .week, .month, .year] }

    private var clampedProgress: CGFloat { min(max(progress, 0), 1) }
    private var fadeProgress: CGFloat { min(clampedProgress * 2, 1) }

    var body: some View {
        if #available(iOS 26.0, *) {
            content
                .background(.white, in: ConcentricRectangle(corners: .concentric(minimum: 24)))
        } else {
            content
                .background(.white, in: RoundedRectangle(cornerRadius: 24))
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: lerp(8, 4, clampedProgress)) {
            HStack {
                if let selectedCategory {
                    Label(selectedCategory.name.uppercased(), systemImage: selectedCategory.icon)
                        .font(.footnote.bold())
                        .foregroundStyle(selectedCategory.color)
                        .lineLimit(1)
                        .truncationMode(.middle)
                } else {
                    Text(selectedPeriod.descriptionResource)
                        .textCase(.uppercase)
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Group {
                    if #available(iOS 26.0, *) {
                        upperMenu.glassEffect()
                    } else {
                        upperMenu
                    }
                }
                .opacity(1 - fadeProgress)
                .allowsHitTesting(fadeProgress < 1)
                .accessibilityHidden(fadeProgress >= 1)
                .onGeometryChange(for: CGRect.self) { $0.frame(in: .named("card")) } action: { upperMenuFrame = $0 }
            }
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }) { headerHeight = $0 }

            CollapsibleTotalMoney(
                money: money,
                progress: clampedProgress,
                headerHeight: headerHeight,
                cardPadding: cardPadding,
                collapsedScale: collapsedScale,
                upperMenuFrame: upperMenuFrame
            )

            SpendingProportionalBar(
                segments: model.chips.map { $0.toSpendingBarSegment() },
                total: model.total,
                selectedIndex: selectedIndex
            )
            .frame(height: lerp(10, 5, clampedProgress))

            CollapsibleCategoryGrid(
                chips: model.chips,
                progress: clampedProgress,
                fadeProgress: fadeProgress
            )
            .onPreferenceChange(SelectedCategoryPreferenceKey.self) { category in
                onSelect(category)
            }
            .padding(.top, 8)
        }
        .padding(cardPadding)
        .coordinateSpace(.named("card"))
        .sheet(isPresented: $showDateRangePicker) {
            DateRangePicker(
                selectedPeriod: $selectedPeriod,
                startDate: selectedPeriod.dates.start,
                endDate: selectedPeriod.dates.end,
                bounds: Date.now.addingTimeInterval(-60*60*24*365*2)..<Date.now
            )
            .presentationDetents([.medium])
        }
        .animation(.easeInOut(duration: 0.3), value: money.amount)
        .animation(.bouncy(duration: 0.3), value: clampedProgress)
    }

    private var upperMenu: some View {
        Menu {
            Picker(.empty, selection: $selectedPeriod) {
                ForEach(availablePickerPeriods, id: \.self) { period in
                    Text(period.descriptionResource)
                }
            }

            Button(.customPeriod) {
                showDateRangePicker = true
            }
        } label: {
            Button(selectedPeriod.datesDescription(locale: locale).localizedCapitalized, systemImage: selectedPeriod.systemImage) { }
        }
        .font(.footnote.weight(.medium))
        .foregroundStyle(.indigo)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.indigo.opacity(0.15), in: .capsule)
        .fixedSize(horizontal: true, vertical: false)
    }

    init(
        model: HeroDashboardModel,
        selectedCategory: CategoryModel?,
        selectedPeriod: Binding<Calendar.Period>,
        progress: CGFloat = 0,
        onSelect: @escaping (CategoryModel?) -> Void
    ) {
        self.model = model
        self.selectedCategory = selectedCategory
        self._selectedPeriod = selectedPeriod
        self.progress = progress
        self.onSelect = onSelect
    }
}

// MARK: - CollapsibleTotalMoney

private struct CollapsibleTotalMoney: View {
    let money: Money
    let progress: CGFloat
    let headerHeight: CGFloat
    let cardPadding: CGFloat
    let collapsedScale: CGFloat
    let upperMenuFrame: CGRect

    @State private var naturalSize: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Placeholder: holds vertical space in VStack and collapses it as progress increases.
        // The visible TotalMoney is in an overlay so it floats freely above the collapsing frame.
        TotalMoney(money: money)
            .fixedSize(horizontal: false, vertical: true)
            .onGeometryChange(for: CGSize.self, of: { $0.size }) { naturalSize = $0 }
            .frame(height: naturalSize.height > 0 ? lerp(naturalSize.height, 0, progress) : nil)
            .opacity(0)
            .clipped()
            .accessibilityHidden(true)
            .overlay(alignment: .topLeading) {
                TotalMoney(money: money)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(
                        reduceMotion
                            ? (naturalSize.height > 0 && headerHeight > 0 ? 1 - progress : 0)
                            : (naturalSize.height > 0 && headerHeight > 0 ? 1 : 0)
                    )
                    .scaleEffect(
                        reduceMotion ? 1.0 : lerp(1.0, collapsedScale, progress),
                        anchor: .topLeading
                    )
                    .offset(
                        x: reduceMotion ? 0 : lerp(0, targetOffsetX, progress),
                        y: reduceMotion ? 0 : lerp(0, targetOffsetY, progress)
                    )
                    .allowsHitTesting(false)
            }
    }

    // Offsets are in CollapsibleTotalMoney-local space (origin = placeholder top-leading).
    // At progress=0 → (0,0): TotalMoney stays at natural position.
    // At progress=1 → moves to header trailing area where the upper menu sits.
    private var targetOffsetX: CGFloat {
        upperMenuFrame.maxX - naturalSize.width * collapsedScale - cardPadding
    }

    private var targetOffsetY: CGFloat {
        upperMenuFrame.midY - naturalSize.height * collapsedScale / 2 - cardPadding - headerHeight
    }
}

// MARK: - CollapsibleCategoryGrid

private struct CollapsibleCategoryGrid: View {
    let chips: [HeroDashboardModel.ChipModel]
    let progress: CGFloat
    let fadeProgress: CGFloat

    @State private var naturalHeight: CGFloat = 0

    var body: some View {
        ExpenseCategoryGrid(chips: chips)
            .opacity(1 - fadeProgress)
            .allowsHitTesting(fadeProgress < 1)
            .accessibilityHidden(fadeProgress >= 1)
            .fixedSize(horizontal: false, vertical: true)
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }) { naturalHeight = $0 }
            .animation(.bouncy(duration: 0.3), value: progress)
            .frame(height: naturalHeight > 0 ? lerp(naturalHeight, 0, progress) : nil)
            .clipped()
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
            ),
            HeroDashboardModel.ChipModel(
                amount: 90,
                category: CategoryModel(name: "Transport", icon: "car.fill", color: .blue)
            ),
            HeroDashboardModel.ChipModel(
                amount: 120,
                category: CategoryModel(name: "Coffee", icon: "cup.and.saucer.fill", color: .brown)
            ),
            HeroDashboardModel.ChipModel(
                amount: 300,
                category: CategoryModel(name: "Rent", icon: "house.fill", color: .red)
            ),
            HeroDashboardModel.ChipModel(
                amount: 60,
                category: CategoryModel(name: "Health", icon: "cross.fill", color: .pink)
            ),
            HeroDashboardModel.ChipModel(
                amount: 75,
                category: CategoryModel(name: "Entertainment", icon: "gamecontroller.fill", color: .indigo)
            )
        ]
    )

    HeroDashboardCard(
        model: model,
        selectedCategory: nil,
        selectedPeriod: $selectedPeriod,
        onSelect: { _ in }
    )
        .padding(16)
}
