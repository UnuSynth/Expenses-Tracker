//
//  BinaryFloatingPoint+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 26/4/26.
//

import Foundation

extension BinaryFloatingPoint {
    // incorrect unicode symbol render fix
    func formatted(currency: String) -> String {
        guard currency == "KGS" else {
            return self.formatted(.currency(code: currency)
                .locale(Locale(identifier: "en_US"))
                .presentation(.narrow))
        }
        
        return self.formatted(.currency(code: "USD")
            .locale(Locale(identifier: "en_US"))
            .presentation(.narrow))
            .replacingOccurrences(of: "$", with: "")
            .appending(" \(String.som)")
    }
}
