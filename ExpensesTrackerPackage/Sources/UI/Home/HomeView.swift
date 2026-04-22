//
//  HomeView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 10/2/26.
//

import SwiftUI
import SwiftData

private enum HomeDestination: Hashable {
    case transactionsHistory
}

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    @Query private var todayExpenses: [ExpenseDBModel]
    
    init(viewModel: HomeViewModel) {
        let todayDates = Calendar.Period.day.dates
        let startDate = todayDates.start
        let endDate = todayDates.end
        
        _todayExpenses = Query(
            filter: #Predicate<ExpenseDBModel> {
                $0.date >= startDate && $0.date < endDate
            }
        )
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            NavigationLink(value: HomeDestination.transactionsHistory) {
                HomeViewExpensesTodayCell(
                    model: viewModel.prepareTodayExpensesModel(expenses: todayExpenses)
                )
                .background(
                    .white,
                    in: .rect(corners: .concentric(minimum: 16))
                )
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(for: HomeDestination.self) { _ in
            HistoryView(viewModel: viewModel.prepareTransactionsHistoryViewModel())
        }
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
    }
}

#Preview {
    HomeView(viewModel: HomeMockViewModel())
}
