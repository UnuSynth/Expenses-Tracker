//
//  HomeView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 10/2/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    @Query(sort: \ExpenseDBModel.date, order: .reverse) private var expenses: [ExpenseDBModel]

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            HeroDashboardCard(
                selectedPeriod: $viewModel.selectedPeriod,
                model: viewModel.spendingHeroModel
            )
            .onCategorySelect { category in
                viewModel.selectedCategoryFilter = category
            }

            let groups = viewModel.groupedExpenses

            if groups.isEmpty {
                ExpenseListEmptyState(
                    category: viewModel.selectedCategoryFilter,
                    period: viewModel.selectedPeriod
                )
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(groups, id: \.date) { group in
                        Section {
                            VStack(spacing: 0) {
                                ForEach(Array(group.items.enumerated()), id: \.element.id) { index, expense in
                                    ExpenseListRow(expense: expense)
                                    if index < group.items.count - 1 {
                                        Divider()
                                            .padding(.leading, 68)
                                    }
                                }
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.bottom, 8)
                        } header: {
                            ExpenseListSectionHeader(
                                label: group.date.relativeLabel,
                                total: group.total
                            )
                        }
                    }
                }
                .padding(.top, 16)
            }
        }
        .padding(.horizontal, 16)
        .searchable(
            text: $viewModel.searchText,
            placement: .toolbar,
            prompt: "Search expenses"
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.partnerButtonTapped()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .clipShape(.circle)
                }
                .accessibilityLabel("View partner")
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Expense", systemImage: "plus", action: viewModel.addExpenseButtonTapped)
            }
        }
        .sheet(isPresented: $viewModel.showPartnerSheet) {
            PartnerLinkView()
        }
        .sheet(isPresented: $viewModel.showingAddExpenseSheet) {
            AddExpenseView(
                viewModel: viewModel.prepareAddExpenseViewModel()
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: expenses, initial: true) {
            viewModel.updateExpenses(expenses)
        }
        .background(.background.secondary)
    }
}

// MARK: - Section Header

private struct ExpenseListSectionHeader: View {
    let label: String
    let total: Double

    var body: some View {
        HStack {
            Text(label.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            Text(total, format: .currency(code: "USD"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
        .background(.clear)
    }
}

// MARK: - Expense Row

private struct ExpenseListRow: View {
    let expense: ExpenseDBModel

    private var timeText: String {
        expense.date.formatted(.dateTime.hour().minute())
    }
    
    private var titleText: String {
        guard let desc = expense.notes?.desc, !desc.isEmpty else {
            return expense.category.displayName
        }
        
        return desc
    }

    private var subtitleText: String {
        if expense.notes?.desc != nil, expense.notes?.desc?.isEmpty == false {
            return "\(expense.category.displayName) · \(timeText)"
        } else {
            return timeText
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: expense.category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(expense.category.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titleText)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(subtitleText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(expense.amount, format: .currency(code: "USD"))
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Empty State

private struct ExpenseListEmptyState: View {
    let category: ExpenseModel.Category?
    let period: Calendar.Period

    private var subtitle: String {
        let periodText = period.description.lowercased()
        if let category {
            return "No \(category.displayName) expenses in \(periodText)."
        } else {
            return "No expenses in \(periodText)."
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("No Results")
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModelImpl())
    }
}
