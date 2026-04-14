//
//  RepositoryAssembly.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import Swinject
import SwinjectAutoregistration

final class RepositoriesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(
            ExpensesRepositoryProtocol.self,
            initializer: ExpensesRepository.init
        )
    }
}
