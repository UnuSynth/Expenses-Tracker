//
//  UIAssembly.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import Swinject
import SwinjectAutoregistration

class UIAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(
            HomeView.ViewModel.self,
            initializer: HomeView.ViewModelImpl.init
        )
        
        container.autoregister(
            AddExpenseView.ViewModel.self,
            initializer: AddExpenseView.ViewModelImpl.init
        )
        
        container.autoregister(
            TransactionsHistoryView.ViewModel.self,
            initializer: TransactionsHistoryView.ViewModelImpl.init
        )
    }
}
