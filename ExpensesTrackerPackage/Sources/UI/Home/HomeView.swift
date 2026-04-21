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
    @State private var viewModel: ViewModel

    @Query private var todayExpenses: [ExpenseDBModel]
    
    init(viewModel: ViewModel) {
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
            TransactionsHistoryView(viewModel: viewModel.prepareTransactionsHistoryViewModel())
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Expense", systemImage: "plus", action: viewModel.addExpenseButtonTapped)
            }
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
    HomeView(viewModel: HomeView.MockViewModel())
}
