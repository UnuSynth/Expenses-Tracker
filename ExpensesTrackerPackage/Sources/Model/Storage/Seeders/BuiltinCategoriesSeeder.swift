//
//  BuiltinCategoriesSeeder.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import SwiftData

public struct BuiltinCategoriesSeeder {
    private struct BuiltinDefinition {
        let name: String
        let icon: String
        let color: Color
    }

    private static let definitions: [BuiltinDefinition] = [
        BuiltinDefinition(name: "Groceries",       icon: "cart.fill",              color: .green),
        BuiltinDefinition(name: "Dining & Cafe",   icon: "fork.knife",             color: .orange),
        BuiltinDefinition(name: "Transport",        icon: "car.fill",               color: .blue),
        BuiltinDefinition(name: "Shopping",         icon: "bag.fill",               color: .pink),
        BuiltinDefinition(name: "Health",           icon: "heart.fill",             color: .red),
        BuiltinDefinition(name: "Housing",          icon: "building.2.fill",        color: .brown),
        BuiltinDefinition(name: "Entertainment",    icon: "popcorn.fill",           color: .purple),
        BuiltinDefinition(name: "Bills & Utilities",icon: "lightbulb.fill",         color: .gray),
        BuiltinDefinition(name: "Travel",           icon: "airplane",               color: .cyan),
        BuiltinDefinition(name: "Other",            icon: "ellipsis.circle.fill",   color: .indigo),
    ]

    public static func seed(into context: ModelContext) {
        guard (try? context.fetch(FetchDescriptor<CategoryModel>()))?.isEmpty ?? false else {
            return
        }
        
        for (i, definition) in definitions.enumerated() {
            context.insert(CategoryModel(
                name: definition.name,
                icon: definition.icon,
                color: definition.color,
                isCustom: false,
                sortOrder: i
            ))
        }
        
        if context.hasChanges {
            try? context.save()
        }
    }
}
