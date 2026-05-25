//
//  HomeViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 24/3/26.
//

import Foundation

@MainActor
protocol HomeViewModel: AnyObject, Observable {
    var spendingHeroModel: HeroDashboardModel { get }
    var showPartnerSheet: Bool { get set }
    var showingAddExpenseSheet: Bool { get set }
    
    func partnerButtonTapped()
    func addExpenseButtonTapped()
    func prepareSpendingHeroModel(expenses: [ExpenseDBModel])
    func prepareAddExpenseViewModel() -> AddExpenseViewModel
    func prepareTransactionsHistoryViewModel() -> HistoryViewModel
}

extension HomeViewModel {
    func partnerButtonTapped() {
        showPartnerSheet = true
    }
    
    func addExpenseButtonTapped() {
        showingAddExpenseSheet = true
    }
}
