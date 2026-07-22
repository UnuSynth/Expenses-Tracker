//
//  CategoryModel.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import SwiftData

@Model
public final class CategoryModel {
    @Attribute(.unique) public var name: String
    /// Stable localization key for built-in categories (e.g. "category.groceries").
    /// `nil` for user-created categories, which display `name` as-is.
    public var key: String?
    public var icon: String
    private var colorComponents: ColorComponents
    public var isCustom: Bool
    public var sortOrder: Int
    
    @Relationship(deleteRule: .cascade, inverse: \ExpenseDBModel.category)
    private var expenses: [ExpenseDBModel] = []
    
    public var color: Color {
        get {
            colorComponents.color
        }
        
        set {
            self.colorComponents = .init(color: newValue)
        }
    }

    public init(
        name: String,
        key: String? = nil,
        icon: String,
        color: Color,
        isCustom: Bool = false,
        sortOrder: Int = 0
    ) {
        self.name = name
        self.key = key
        self.icon = icon
        self.colorComponents = .init(color: .clear)
        self.isCustom = isCustom
        self.sortOrder = sortOrder
        
        self.color = color
    }
}

extension CategoryModel: Equatable {
    public static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name == rhs.name
        && lhs.icon == rhs.icon
        && lhs.colorComponents == rhs.colorComponents
    }
}
