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

    @Query(sort: \ExpenseDBModel.date, order: .reverse) private var expenses: [ExpenseDBModel]
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            NavigationLink(value: HomeDestination.transactionsHistory) {
                SpendingHeroCard(
                    model: viewModel.prepareSpendingHeroModel(expenses: expenses)
                )
                .padding([.horizontal, .top], 16)
            }
            .buttonStyle(.plain)
            
            HighlightsStrip(
                transactions: Array(expenses.map { $0.toEntity() })
            )
            .padding(.top, 24)
        }
        .navigationDestination(for: HomeDestination.self) { destination in
            if case .transactionsHistory = destination {
                HistoryView(viewModel: viewModel.prepareTransactionsHistoryViewModel())
            }
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
