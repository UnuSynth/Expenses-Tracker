//
//  String.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/4/26.
//

import Foundation

extension String {
    static let som = "c̲"
    
    func toDouble() -> Double? {
        guard last != "," else { return nil } // ensure that user finished number input
        
        return Double(
            self.replacingOccurrences(
                of: ",",
                with: "."
            )
        )
    }
}
