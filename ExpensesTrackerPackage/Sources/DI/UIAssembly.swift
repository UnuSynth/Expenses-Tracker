//
//  UIAssembly.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import Swinject
import SwinjectAutoregistration

@MainActor
final class UIAssembly: @preconcurrency Assembly {
    func assemble(container: Container) {
        container.autoregister(
            HomeViewModel.self,
            initializer: HomeViewModelImpl.init
        )
        
        container.autoregister(
            ExpenseEditorViewModel.self,
            initializer: AddExpenseViewModelImpl.init
        )
        
        container.autoregister(
            ExpenseEditorViewModel.self,
            argument: ExpenseDBModel.self,
            initializer: EditExpenseViewModel.init
        )

        container.autoregister(
            CategoriesSettingsViewModel.self,
            initializer: CategoriesSettingsViewModelImpl.init
        )
    }
}
