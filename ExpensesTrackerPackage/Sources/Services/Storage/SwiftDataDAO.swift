//
//  ExpensesDAO.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 20/2/26.
//

import Foundation
import SwiftData

//@MainActor
protocol SwiftDataDAOProtocol {
    func save<T: PersistentModel>(model: T, force: Bool)
    func get<T: PersistentModel>(
        model: T.Type,
        predicate: Predicate<T>?,
        sortBy: [SortDescriptor<T>]
    ) throws -> [T]
}

extension SwiftDataDAOProtocol {
    func save<T: PersistentModel>(model: T) {
        save(model: model, force: false)
    }
}

extension SwiftDataDAOProtocol {
    func get<T: PersistentModel>(model: T.Type) throws -> [T] {
        return try get(model: model, predicate: nil)
    }
    
    func get<T: PersistentModel>(
        model: T.Type,
        predicate: Predicate<T>?
    ) throws -> [T] {
        return try get(model: model, predicate: predicate, sortBy: [])
    }
}

final class SwiftDataDAO: SwiftDataDAOProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save<T: PersistentModel>(model: T, force: Bool) {
        context.insert(model)
        
        if force, context.hasChanges {
            try? context.save()
        }
    }
    
    func get<T: PersistentModel>(
        model: T.Type,
        predicate: Predicate<T>?,
        sortBy: [SortDescriptor<T>]
    ) throws -> [T] {
        return try context.fetch(
            .init(
                predicate: predicate,
                sortBy: sortBy
            )
        )
    }
}
