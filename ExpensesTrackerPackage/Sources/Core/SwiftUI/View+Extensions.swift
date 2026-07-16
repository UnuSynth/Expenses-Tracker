//
//  View+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 23/6/26.
//

import SwiftUI

extension View {
    func withoutAnimation(_ action: () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
