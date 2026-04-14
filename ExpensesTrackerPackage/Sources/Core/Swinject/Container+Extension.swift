//
//  Container+Extension.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 10/4/26.
//

import Swinject

extension Container {
    func assemble(assemblies: [Assembly]) {
        assemblies.forEach { $0.assemble(container: self) }
    }
}
