//
//  TransactionsHistoryView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 14/4/26.
//

import SwiftUI

struct TransactionsHistoryView: View {
    @State var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .background(.background.secondary)
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
                TransactionsHistorySummaryCard(
                    summaryAmount: viewModel.summaryAmount,
                    summaryTitle: viewModel.summaryTitle
                )
                TransactionsHistoryChartCard(viewModel: viewModel)
                TransactionsHistoryTransactionsSection(groups: viewModel.groupedTransactions)
            }
            .padding(16)
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsHistoryView(viewModel: TransactionsHistoryView.MockViewModel())
    }
}
