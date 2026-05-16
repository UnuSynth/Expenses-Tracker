//
//  DateRangePickerView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 15/5/26.
//

import SwiftUI

struct DateRangePicker: View {
    @Binding private var selectedPeriod: Calendar.Period
    @State private var startDate: Date?
    @State private var endDate: Date?
    let bounds: Range<Date>?
    @Environment(\.dismiss) private var dismiss
    
    private var defaultBounds: Range<Date> {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .month, value: -6, to: Date()) ?? .now
        let end = calendar.date(byAdding: .month, value: 6, to: Date()) ?? .now
        return start..<end
    }
    
    private var datesBinding: Binding<Set<DateComponents>> {
        Binding {
            DateRangeHelper.getDatesInRange(
                startDate: startDate,
                endDate: endDate,
                calendar: .current
            )
        } set: { newValue in
            DateRangeHelper.setDateRangeFromSelection(
                newValue: newValue,
                calendar: .current,
                startDate: &startDate,
                endDate: &endDate
            )
        }
    }

    init(
        selectedPeriod: Binding<Calendar.Period>,
        startDate: Date,
        endDate: Date,
        bounds: Range<Date>? = nil
    ) {
        self._selectedPeriod = selectedPeriod
        self.startDate = startDate
        self.endDate = endDate
        self.bounds = bounds
    }

    var body: some View {
        NavigationStack {
            MultiDatePicker("", selection: datesBinding, in: bounds ?? defaultBounds)
                .padding()
                .navigationTitle("Custom Period")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .close) { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) { apply() }
                            .disabled(datesBinding.wrappedValue.isEmpty)
                    }
                }
        }
    }

    private func apply() {
        let dates = datesBinding.wrappedValue
            .compactMap { Calendar.current.date(from: $0) }
            .sorted()
        guard let first = dates.first, let last = dates.last else { return }
        selectedPeriod = .custom(start: first, end: last)
        dismiss()
    }
}

#Preview {
    @Previewable @State var selectedPeriod = Calendar.Period.day
    @Previewable @State var start = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .now
    @Previewable @State var end: Date = Date.now
    DateRangePicker(
        selectedPeriod: $selectedPeriod,
        startDate: start,
        endDate: end
    )
}
