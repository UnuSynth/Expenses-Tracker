//
//  TransactionsHistoryChartCard.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import Charts

struct TransactionsHistoryChartCard: View {
    let viewModel: any HistoryViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            timePeriodSelector
            expenseChart
            statsRow
                .padding(.top, 4)
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    // MARK: - Period Selector
    
    private var timePeriodSelector: some View {
        HStack(spacing: 0) {
            ForEach(HistoryTimePeriod.allCases, id: \.self) { period in
                Button(period.rawValue) {
                    withAnimation(.linear(duration: 0.3)) {
                        viewModel.selectedPeriod = period
                        viewModel.selectedBarDate = nil
                    }
                }
                .font(.subheadline.weight(.semibold))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .foregroundStyle(viewModel.selectedPeriod == period ? .white : Color.accentColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedPeriod == period ? Color.accentColor : .clear)
                )
            }
        }
        .padding(3)
        .background(Color(.systemFill), in: RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Chart
    
    private var expenseChart: some View {
        Chart {
            RuleMark(y: .value("Average", viewModel.averageAmount))
                .foregroundStyle(.secondary.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .annotation(position: .trailing) {
                    Text("Avg")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            
            ForEach(viewModel.chartData) { item in
                BarMark(
                    x: .value("Date", item.dateStart, unit: viewModel.selectedPeriod.calendarComponent),
                    y: .value("Amount", item.total)
                )
                .foregroundStyle(viewModel.barColor(for: item.dateStart))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .annotation(position: .top, spacing: 4) {
                    if let selectedDate = viewModel.selectedBarDate,
                       item.dateStart.matches(selectedDate, by: viewModel.selectedPeriod.calendarComponent) {
                        Text(item.total, format: .currency(code: "USD"))
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .font(.caption2)
            }
        }
        .chartYAxis(.hidden)
        .chartPlotStyle { plotArea in
            plotArea.background(.clear)
        }
        .frame(height: 180)
        .animation(.linear(duration: 0.1), value: viewModel.selectedBarDate)
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard let plotFrame = proxy.plotFrame else { return }
                                let origin = geo[plotFrame].origin
                                let location = CGPoint(
                                    x: value.location.x - origin.x,
                                    y: value.location.y - origin.y
                                )
                                if let date: Date = proxy.value(atX: location.x),
                                   !viewModel.isSameBarDateSelected(date) {
                                    withAnimation(.linear(duration: 0.1)) {
                                        viewModel.selectedBarDate = date
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.linear(duration: 0.15)) {
                                    viewModel.selectedBarDate = nil
                                }
                            }
                    )
            }
        }
    }
    
    // MARK: - Stats Row
    
    private var statsRow: some View {
        HStack(spacing: 0) {
            statTile(label: "Average", value: viewModel.averageAmount)
            Divider().frame(height: 32)
            statTile(label: "High", value: viewModel.highestDay)
            Divider().frame(height: 32)
            statTile(label: "Low", value: viewModel.lowestDay)
        }
        .padding(.vertical, 12)
    }
    
    private func statTile(label: String, value: Double) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TransactionsHistoryChartCard(viewModel: HistoryMockViewModel())
}
