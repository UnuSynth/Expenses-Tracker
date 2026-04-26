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
            AddExpenseViewModel.self,
            initializer: AddExpenseViewModelImpl.init
        )
        
        container.autoregister(
            HistoryViewModel.self,
            initializer: HistoryMockViewModel.init
        )
    }
}
