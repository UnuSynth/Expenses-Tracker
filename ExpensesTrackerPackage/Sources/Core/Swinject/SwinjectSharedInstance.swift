//
//  AppSettings.swift
//  ExpensesTracker
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import SwiftData
import Swinject

nonisolated(unsafe) public let SharedContainer = SwinjectSharedInstance.diContainer

public enum SwinjectSharedInstance {
    nonisolated(unsafe) public static let diContainer: Container = .init()
    
    @MainActor
    public static func setupDIContainer(with modelContainer: ModelContainer) {
        diContainer.register(ModelContainer.self) { _ in
            modelContainer
        }
        
        setup(container: diContainer)
    }
    
    private static func setup(container: Container) {
        container.assemble(
            assemblies: [
                ServicesAssembly(),
                RepositoriesAssembly(),
                UIAssembly()
            ]
        )
    }
}
