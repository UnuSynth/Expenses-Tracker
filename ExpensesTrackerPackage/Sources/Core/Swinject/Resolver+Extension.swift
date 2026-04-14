//
//  Resolver+Extension.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import Swinject

extension Resolver {
    func resolve<Service>(
        _ serviceType: Service.Type,
        releaseSafeInitializer: @autoclosure () -> Service
    ) -> Service {
        return resolve(serviceType)
        ?? releaseSafeInit(builder: releaseSafeInitializer())
    }
    
    private func releaseSafeInit<T>(builder: @autoclosure () -> T) -> T {
        #if DEBUG
        fatalError("\(T.self) have to be registered in Swinject")
        #else
        debugPrint("Warning: You have not registered \(T.self), so it has been initialized directly without DI")
        return builder()
        #endif
    }
}
