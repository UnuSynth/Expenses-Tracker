//
//  TransactionsHistoryView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/4/26.
//

import SwiftUI
import Charts

struct TransactionsHistoryView: View {
    @State var viewModel: ViewModel
    @State private var showAllTransactions = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .background(Color(.systemGroupedBackground))
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadExpenses()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                "Something Went Wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
        } else if viewModel.chartData.isEmpty {
            ContentUnavailableView(
                "No Expenses",
                systemImage: "list.bullet.rectangle",
                description: Text("Start adding expenses to see them here")
            )
        } else {
            mainContent
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 12) {
                summaryHeaderCard
                chartCard
                transactionsSection
            }
            .padding(16)
        }
    }

    // MARK: - Summary Header Card

    private var summaryHeaderCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("EXPENSES")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(viewModel.summaryAmount, format: .currency(code: "USD"))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: viewModel.summaryAmount)

            Text(viewModel.summaryTitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Chart Card

    private var chartCard: some View {
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

    // MARK: - Time Period Selector

    private var timePeriodSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(period.rawValue) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.selectedPeriod = period
                        viewModel.selectedBarDate = nil
                    }
                }
                .font(.subheadline.weight(.semibold))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .foregroundStyle(viewModel.selectedPeriod == period ? .white : Color.accentColor)
                .background(
                    viewModel.selectedPeriod == period
                        ? RoundedRectangle(cornerRadius: 8).fill(Color.accentColor)
                        : RoundedRectangle(cornerRadius: 8).fill(Color.clear)
                )
            }
        }
        .padding(3)
        .background(Color(.systemFill), in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Expense Chart

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
                    x: .value("Date", item.date, unit: viewModel.selectedPeriod.calendarComponent),
                    y: .value("Amount", item.total)
                )
                .foregroundStyle(barColor(for: item.date))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .annotation(position: .top, spacing: 4) {
                    if item.date.isSameDay(as: viewModel.selectedBarDate) {
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
        .animation(.spring(response: 0.4), value: viewModel.selectedPeriod)
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                debugPrint("drag position changed")
                                guard let plotFrame = proxy.plotFrame else { return }
                                let origin = geo[plotFrame].origin
                                let location = CGPoint(
                                    x: value.location.x - origin.x,
                                    y: value.location.y - origin.y
                                )
                                if let date: Date = proxy.value(atX: location.x) {
                                    debugPrint("user selected date: \(date)")
                                    withAnimation(.spring(response: 0.2)) {
                                        viewModel.selectedBarDate = date
                                    }
                                }
                            }
                            .onEnded { _ in
                                debugPrint("drag ended")
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectedBarDate = nil
                                }
                            }
                    )
            }
        }
    }

    private func barColor(for date: Date) -> Color {
        debugPrint("bar color change for date: \(date)")
        debugPrint("selected bar date: \(viewModel.selectedBarDate)")
        if let selected = viewModel.selectedBarDate {
            debugPrint("isSameDay: \(date.isSameDay(as: selected))")
            return date.isSameDay(as: selected)
                ? Color.orange
                : Color.orange.opacity(0.4)
        }
        return Color.orange
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

    // MARK: - Transactions Section

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRANSACTIONS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

            let groups = viewModel.groupedTransactions
            let displayGroups = showAllTransactions ? groups : Array(groups.prefix(3))

            ForEach(displayGroups) { group in
                transactionGroupSection(group: group)
            }

            if groups.count > 3 {
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        showAllTransactions.toggle()
                    }
                } label: {
                    HStack {
                        Text(showAllTransactions ? "Show Less" : "Show All Transactions")
                            .font(.subheadline)
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                        Image(systemName: showAllTransactions ? "chevron.up" : "chevron.down")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func transactionGroupSection(group: ExpenseGroup) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(group.label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGroupedBackground))

            ForEach(group.items.indices, id: \.self) { index in
                let expense = group.items[index]
                transactionRow(expense: expense)
                    .padding(.horizontal, 16)

                if index < group.items.count - 1 {
                    Divider().padding(.leading, 68)
                }
            }
        }
    }

    private func transactionRow(expense: ExpenseModel) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: expense.category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(expense.category.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(expense.category.displayName)
                    .font(.body)
                    .foregroundStyle(.primary)
                if let notes = expense.notes, let desc = notes.desc, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.amount, format: .currency(code: "USD"))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(expense.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
#Preview {
    NavigationStack {
        TransactionsHistoryView(viewModel: TransactionsHistoryView.MockViewModel())
    }
}

