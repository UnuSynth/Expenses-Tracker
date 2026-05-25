//
//  HomeViewModel+Impl.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 25/5/26.
//

import Foundation

@Observable
@MainActor
class HomeViewModelImpl: HomeViewModel {
    var spendingHeroModel: HeroDashboardModel = .init(chips: [])
    var showPartnerSheet: Bool = false
    var showingAddExpenseSheet: Bool = false
    
    private let repository: ExpensesRepositoryProtocol
    private var displayCurrency: String {
        "KGS"
    }
    
    init(repository: ExpensesRepositoryProtocol) {
        self.repository = repository
    }
    
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel]) {
        let totalsByCategory = expenses.reduce(into: [ExpenseModel.Category: Double]()) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }

        let chips: [HeroDashboardModel.ChipModel] = ExpenseModel.Category.allCases.compactMap { category -> HeroDashboardModel.ChipModel? in
            guard let amount = totalsByCategory[category] else {
                return nil
            }

            return HeroDashboardModel.ChipModel(
                amount: amount,
                category: category
            )
        }

        spendingHeroModel = .init(chips: chips)
    }
    
    func prepareAddExpenseViewModel() -> AddExpenseViewModel {
        SharedContainer.resolve(AddExpenseViewModel.self) ?? AddExpenseMockViewModel()
    }
    
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel {
        SharedContainer.resolve(HistoryViewModel.self) ?? HistoryViewModelImpl(repository: repository)
    }
}
