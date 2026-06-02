//
//  HomeViewModel.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 24/3/26.
//

import Foundation
import SwiftUI

@MainActor
protocol HomeViewModel: AnyObject, Observable {
    var selectedPeriod: Calendar.Period { get set }
    var spendingHeroModel: HeroDashboardModel { get }
    var showPartnerSheet: Bool { get set }
    var showingAddExpenseSheet: Bool { get set }
    var searchText: String { get set }
    var selectedCategoryFilter: ExpenseModel.Category? { get set }
    var groupedExpenses: [(date: Date, items: [ExpenseDBModel], total: Double)] { get }
    var addButtonPlacement: ToolbarItemPlacement { get }
    
    func partnerButtonTapped()
    func addExpenseButtonTapped()
    func updateExpenses(_ expenses: [ExpenseDBModel])
    func prepareAddExpenseViewModel() -> AddExpenseViewModel
    func deleteExpense(_ expense: ExpenseDBModel)
}

extension HomeViewModel {
    var addButtonPlacement: ToolbarItemPlacement {
        if #available(iOS 26.0, *) {
            return .bottomBar
        } else {
            return .primaryAction
        }
    }
    
    func partnerButtonTapped() {
        showPartnerSheet = true
    }

    func addExpenseButtonTapped() {
        showingAddExpenseSheet = true
    }
}
