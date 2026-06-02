//
//  Circle.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 2/6/26.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(14)
            .background(
                Circle()
                    .fill(Color(.systemBackground))
            )
            .contentShape(Circle())
            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
