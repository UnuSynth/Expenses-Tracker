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
        VStack {
            HeroDashboardCard(
                selectedPeriod: $viewModel.selectedPeriod,
                model: viewModel.spendingHeroModel
            )
            .onCategorySelect { category in
                viewModel.selectedCategoryFilter = category
            }
            .padding(.horizontal, 16)
            
            List {
                let groups = viewModel.groupedExpenses
                
                if groups.isEmpty {
                    Section {
                        ExpenseListEmptyState(
                            category: viewModel.selectedCategoryFilter,
                            period: viewModel.selectedPeriod
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listSectionSeparator(.hidden)
                } else {
                    ForEach(groups, id: \.date) { group in
                        Section {
                            ForEach(group.items) { expense in
                                ExpenseListRow(expense: expense)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.deleteExpense(expense)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            viewModel.editExpenese(expense)
                                        } label: {
                                            VStack {
                                                Image(systemName: "pencil")
                                                Text("Edit")
                                            }
                                        }
                                        .tint(.blue)
                                    }
                                    .listRowInsets(EdgeInsets())
                                    .alignmentGuide(.listRowSeparatorLeading) { _ in 68 }
                            }
                        } header: {
                            ExpenseListSectionHeader(
                                label: group.date.relativeLabel,
                                total: group.total
                            )
                        }
                        .listSectionSpacing(8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .modifier(SearchBehaviorModifier(searchText: $viewModel.searchText))
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button("Add Expense", systemImage: "plus", action: viewModel.addExpenseButtonTapped)
                    .modifier(AddExpenseButtonBehaviorModifier())
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showPartnerSheet) {
            PartnerLinkView()
        }
        .sheet(isPresented: $viewModel.showingAddExpenseSheet) {
            let detents: Set<PresentationDetent> = UIApplication.screenHeight >= 840 ? [.fraction(0.85), .large] : [.large]
            ExpenseEditorView(
                viewModel: viewModel.prepareAddExpenseViewModel()
            )
            .presentationDetents(detents)
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $viewModel.showingEditExpenseSheet) {
            let detents: Set<PresentationDetent> = UIApplication.screenHeight >= 840 ? [.fraction(0.85), .large] : [.large]
            ExpenseEditorView(
                viewModel: viewModel.prepareEditExpenseViewModel()
            )
            .presentationDetents(detents)
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: expenses, initial: true) {
            viewModel.updateExpenses(expenses)
        }
        .background(.background.secondary)
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModelImpl(repository: ExpensesRepositoryMock()))
    }
}
 
