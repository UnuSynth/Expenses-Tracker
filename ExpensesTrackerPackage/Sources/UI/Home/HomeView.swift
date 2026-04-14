//
//  HomeView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 10/2/26.
//

import SwiftUI
import SwiftData

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
            HomeViewExpensesTodayCell(
                model: viewModel.prepareTodayExpensesModel(expenses: todayExpenses)
            )
                .background(
                    .white,
                    in: .rect(
                        corners: .concentric(
                            minimum: 16
                        )
                    )
                )
        }
        .toolbar {
            ToolbarItemGroup(
                placement: .bottomBar
            ) {
                Button(
                    "",
                    systemImage: "plus",
                    action: viewModel.addExpenseButtonTapped
                )
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
