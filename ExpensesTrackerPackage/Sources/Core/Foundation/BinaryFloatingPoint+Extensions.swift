//
//  BinaryFloatingPoint+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 26/4/26.
//

extension BinaryFloatingPoint {
    // incorrect unicode symbol render fix
    func formatted(currency: String) -> String {
        guard currency == "KGS" else {
            return self.formatted(.currency(code: currency).presentation(.narrow))
        }
        
        return "\(self) \(String.som)"
    }
}
