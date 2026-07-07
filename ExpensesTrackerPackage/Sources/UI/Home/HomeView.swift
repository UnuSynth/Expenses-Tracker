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
    @State private var isTracking = false
    @State private var collapseProgress: CGFloat = 0
    @State private var collapseDistance: CGFloat = 0
    @State private var sensitivity: CGFloat = 150

    @Environment(\.modelContext) private var context
    @Environment(\.locale) private var locale
    @Query(sort: \ExpenseDBModel.date, order: .reverse) private var expenses: [ExpenseDBModel]

    @AppStorage(AppStorageKeys.currency.key) private var selectedCurrencyRaw: String = Currency.usd.rawValue
    private var currency: Currency { .initialize(rawValue: selectedCurrencyRaw) }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HeroDashboardCard(
                selectedPeriod: $viewModel.selectedPeriod,
                model: viewModel.spendingHeroModel,
                progress: collapseProgress
            )
            .onCategorySelect { category in
                viewModel.selectedCategoryFilter = category
            }
            .padding(.horizontal, 16)
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }) { height in
                // Only capture the expanded height; ignore changes caused by collapse itself.
                if collapseProgress == 0 {
                    sensitivity = height
                }
            }

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
                                ExpenseListRow(expense: expense, currency: currency)
                                    .swipeActions(
                                        edge: .trailing,
                                        allowsFullSwipe: true
                                    ) {
                                        deleteAction(expense: expense)
                                        editAction(expense: expense)
                                    }
                                    .listRowInsets(EdgeInsets())
                                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                                        return 68
                                    }
                            }
                        } header: {
                            ExpenseListSectionHeader(
                                label: group.date.relativeLabel(locale: locale),
                                total: group.total,
                                currency: currency
                            )
                        }
                        .listSectionSpacing(8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .modifier(SearchBehaviorModifier(searchText: $viewModel.searchText))
            .scrollDismissesKeyboard(.interactively)
            .onScrollGeometryChange(for: CGFloat.self, of: { $0.contentOffset.y }) { oldY, newY in
                guard isTracking else { return }
                guard !viewModel.groupedExpenses.isEmpty else { return }
                let delta = newY - oldY
                let newProgress = min(1, max(0, collapseProgress + delta / sensitivity))
                collapseProgress = newProgress
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                isTracking = newPhase == .interacting
                
                if !isTracking {
                    withAnimation(.spring(duration: 0.3)) {
                        collapseProgress = collapseProgress > 0.5 ? 1 : 0
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(.addExpense, systemImage: "plus", action: viewModel.addExpenseButtonTapped)
                    .modifier(AddExpenseButtonBehaviorModifier())
                Spacer()
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.settingsButtonTapped()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .clipShape(.circle)
                }
                .accessibilityLabel(.viewPartner)
            }
        }
        .sheet(isPresented: $viewModel.showSettingsSheet) {
            SettingsView()
        }
        .sheet(isPresented: $viewModel.showingAddExpenseSheet) {
            let detents: Set<PresentationDetent> = UIApplication.screenHeight >= 840 ? [.fraction(0.85), .large] : [.large]
            ExpenseEditorView()
            .presentationDetents(detents)
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $viewModel.showingEditExpenseSheet) {
            let detents: Set<PresentationDetent> = UIApplication.screenHeight >= 840 ? [.fraction(0.85), .large] : [.large]
            ExpenseEditorView(expense: viewModel.toEditExpense)
            .presentationDetents(detents)
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: expenses, initial: true) {
            viewModel.updateExpenses(expenses)
        }
        .onReceive(NotificationCenter.default.publisher(for: ModelContext.didSave), perform: { output in
            guard (output.userInfo?["updated"] as? [PersistentIdentifier])?.contains(where: { $0.entityName == String(describing: ExpenseDBModel.self) }) == true else { return }
            viewModel.updateExpenses(expenses)
        })
        .background(.background.secondary)
    }

    private func deleteAction(expense: ExpenseDBModel) -> some View {
        Button(role: .destructive) {
            context.delete(expense)
        } label: {
            Label(.delete, systemImage: "trash")
        }
    }

    private func editAction(expense: ExpenseDBModel) -> some View {
        Button {
            viewModel.editExpenese(expense)
        } label: {
            Label(.edit, systemImage: "pencil")
        }
        .tint(.orange)
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModelImpl())
    }
}
