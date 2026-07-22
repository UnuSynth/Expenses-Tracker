//
//  BuiltinCategoriesSeeder.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import SwiftData

public struct BuiltinCategoriesSeeder {
    private struct BuiltinDefinition {
        let name: String
        let key: String
        let icon: String
        let color: Color
    }

    private static let definitions: [BuiltinDefinition] = [
        BuiltinDefinition(
            name: "Groceries",
            key: LocalizedStringResource.categoryGroceries.key,
            icon: "cart.fill",
            color: .green
        ),
        BuiltinDefinition(
            name: "Dining & Cafe",
            key: LocalizedStringResource.categoryDining.key,
            icon: "fork.knife",
            color: .orange
        ),
        BuiltinDefinition(
            name: "Transport",
            key: LocalizedStringResource.categoryTransport.key,
            icon: "car.fill",
            color: .blue
        ),
        BuiltinDefinition(
            name: "Shopping",
            key: LocalizedStringResource.categoryShopping.key,
            icon: "bag.fill",
            color: .pink
        ),
        BuiltinDefinition(
            name: "Health",
            key: LocalizedStringResource.categoryHealth.key,
            icon: "heart.fill",
            color: .red
        ),
        BuiltinDefinition(
            name: "Housing",
            key: LocalizedStringResource.categoryHousing.key,
            icon: "building.2.fill",
            color: .brown
        ),
        BuiltinDefinition(
            name: "Entertainment",
            key: LocalizedStringResource.categoryEntertainment.key,
            icon: "popcorn.fill",
            color: .purple
        ),
        BuiltinDefinition(
            name: "Bills & Utilities",
            key: LocalizedStringResource.categoryBills.key,
            icon: "lightbulb.fill",
            color: .gray
        ),
        BuiltinDefinition(
            name: "Travel",
            key: LocalizedStringResource.categoryTravel.key,
            icon: "airplane",
            color: .cyan
        ),
        BuiltinDefinition(
            name: "Other",
            key: LocalizedStringResource.categoryOther.key,
            icon: "ellipsis.circle.fill",
            color: .indigo
        ),
    ]

    public static func seed(into context: ModelContext) {
        guard (try? context.fetch(FetchDescriptor<CategoryModel>()))?.isEmpty ?? false else {
            return
        }

        for (i, definition) in definitions.enumerated() {
            context.insert(CategoryModel(
                name: definition.name,
                key: definition.key,
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
