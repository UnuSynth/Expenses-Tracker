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
    var searchText: String { get set }
    var selectedCategoryFilter: ExpenseModel.Category? { get set }
    var groupedExpenses: [(date: Date, items: [ExpenseDBModel], total: Double)] { get }
    var addButtonPlacement: ToolbarItemPlacement { get }
    
    func updateExpenses(_ expenses: [ExpenseDBModel])
    
    // MARK: - Sheet States
    var showPartnerSheet: Bool { get set }
    var showingAddExpenseSheet: Bool { get set }
    var showingEditExpenseSheet: Bool { get set }
    
    // MARK: - Button Tap Handlers
    func addExpenseButtonTapped()
    func partnerButtonTapped()
    
    // MARK: - Prepare View Model Methods
    func prepareAddExpenseViewModel() -> ExpenseEditorViewModel
    func prepareEditExpenseViewModel() -> ExpenseEditorViewModel
    
    // MARK: - Delete/Edit expense Methods
    func deleteExpense(_ expense: ExpenseDBModel)
    func editExpenese(_ expense: ExpenseDBModel)
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
    
    func prepareAddExpenseViewModel() -> ExpenseEditorViewModel {
        SharedContainer.resolve(ExpenseEditorViewModel.self) ?? ExpenseEditorViewModelMock()
    }
}
