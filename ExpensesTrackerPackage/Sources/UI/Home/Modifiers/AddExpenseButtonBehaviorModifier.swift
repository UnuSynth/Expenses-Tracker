//
//  AddExpenseButtonBehaviorModifier.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 2/6/26.
//

import SwiftUI

struct AddExpenseButtonBehaviorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
        } else {
            content
                .buttonStyle(CircleButtonStyle())
        }
    }
}
