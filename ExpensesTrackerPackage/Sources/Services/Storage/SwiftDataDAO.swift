//
//  ExpensesDAO.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 20/2/26.
//

import Foundation
import SwiftData

@MainActor
protocol SwiftDataDAOProtocol {
    func save<T>(model: T, force: Bool) throws where T : PersistentModel
    func getCount<T>(type: T.Type, predicate: Predicate<T>?) throws -> Int where T : PersistentModel
    func delete<T>(type: T.Type, predicate: Predicate<T>) throws where T : PersistentModel
}

extension SwiftDataDAOProtocol {
    func save<T: PersistentModel>(model: T) throws {
        try save(model: model, force: false)
    }
}

@MainActor
final class SwiftDataDAO: SwiftDataDAOProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save<T>(model: T, force: Bool) throws where T : PersistentModel {
        context.insert(model)
        
        if force, context.hasChanges {
            try context.save()
        }
    }
    
    func getCount<T>(
        type: T.Type,
        predicate: Predicate<T>?
    ) throws -> Int where T : PersistentModel {
        return try context.fetchCount(
            .init(
                predicate: predicate
            )
        )
    }
    
    func delete<T>(type: T.Type, predicate: Predicate<T>) throws where T : PersistentModel {
        try context.delete(
            model: type,
            where: predicate,
            includeSubclasses: false
        )
        
        if context.hasChanges {
            try context.save()
        }
    }
}
