//
//  ServicesAssembly.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import SwiftData
import Swinject

@MainActor
final class ServicesAssembly: @preconcurrency Assembly {
    func assemble(container: Container) {
        container.autoregister(
            SwiftDataDAOProtocol.self,
            initializer: SwiftDataDAO.init
        )
        
        container.autoregister(
            ExpensesDBManagerProtocol.self,
            initializer: ExpensesDBManager.init
        )
    }
}
