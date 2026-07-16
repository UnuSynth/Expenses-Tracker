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
    var currency: Currency { get set }
    var searchText: String { get set }
    var selectedCategoryFilter: CategoryModel? { get set }
    var groupedExpenses: [(date: Date, items: [ExpenseDBModel], total: Double)] { get }
    var addButtonPlacement: ToolbarItemPlacement { get }
    var collapseProgress: CGFloat { get }
    
    func updateExpenses(_ expenses: [ExpenseDBModel])
    
    // MARK: - Sheet States
    var showSettingsSheet: Bool { get set }
    var showingAddExpenseSheet: Bool { get set }
    var showingEditExpenseSheet: Bool { get set }
    var toEditExpense: ExpenseDBModel? { get }
    
    // MARK: - Button Tap Handlers
    func addExpenseButtonTapped()
    func settingsButtonTapped()
    
    // MARK: - Delete/Edit expense Methods
    func editExpenese(_ expense: ExpenseDBModel)
    
    // MARK: - Drag Handlers
    func handleShowHideDashboard(drag: DragGesture.Value)
}

extension HomeViewModel {
    var addButtonPlacement: ToolbarItemPlacement {
        if #available(iOS 26.0, *) {
            return .bottomBar
        } else {
            return .primaryAction
        }
    }
    
    func settingsButtonTapped() {
        showSettingsSheet = true
    }

    func addExpenseButtonTapped() {
        showingAddExpenseSheet = true
    }
}
