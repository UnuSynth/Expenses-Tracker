//
//  BuiltinCategoriesSeeder.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import SwiftData

public struct BuiltinCategoriesSeeder {
    private struct BuiltinDefinition {
        let name: String
        let displayName: String
        let icon: String
        let color: Color
    }

    private static let definitions: [BuiltinDefinition] = [
        BuiltinDefinition(name: "groceries",    displayName: "Groceries",       icon: "cart.fill",              color: .green),
        BuiltinDefinition(name: "dining",       displayName: "Dining & Cafe",   icon: "fork.knife",             color: .orange),
        BuiltinDefinition(name: "transport",    displayName: "Transport",        icon: "car.fill",               color: .blue),
        BuiltinDefinition(name: "shopping",     displayName: "Shopping",         icon: "bag.fill",               color: .pink),
        BuiltinDefinition(name: "health",       displayName: "Health",           icon: "heart.fill",             color: .red),
        BuiltinDefinition(name: "housing",      displayName: "Housing",          icon: "building.2.fill",        color: .brown),
        BuiltinDefinition(name: "entertainment",displayName: "Entertainment",    icon: "popcorn.fill",           color: .purple),
        BuiltinDefinition(name: "bills",        displayName: "Bills & Utilities",icon: "lightbulb.fill",         color: .gray),
        BuiltinDefinition(name: "travel",       displayName: "Travel",           icon: "airplane",               color: .cyan),
        BuiltinDefinition(name: "other",        displayName: "Other",            icon: "ellipsis.circle.fill",   color: .indigo),
    ]

    public static func seed(into context: ModelContext) {
        guard (try? context.fetch(FetchDescriptor<CategoryModel>()))?.isEmpty ?? false else {
            return
        }
        
        for (i, definition) in definitions.enumerated() {
            context.insert(CategoryModel(
                name: definition.name,
                displayName: definition.displayName,
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
