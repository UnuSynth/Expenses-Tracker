//
//  CapsuleButtonBehaviorModifier.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 1/6/26.
//

import SwiftUI

struct CapsuleButtonBehaviorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.interactive(), in: .capsule)
        } else {
            content
                .background(.indigo.opacity(0.15), in: .capsule)
        }
    }
}
