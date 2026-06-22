//
//  ColorComponents.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 22/6/26.
//

import SwiftUI

struct ColorComponents: Codable, Equatable {
    let red: Float
    let green: Float
    let blue: Float
    
    init(
        red: Float,
        green: Float,
        blue: Float
    ) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(color: Color) {
        let resolved = color.resolve(in: EnvironmentValues())
        
        self.init(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}
