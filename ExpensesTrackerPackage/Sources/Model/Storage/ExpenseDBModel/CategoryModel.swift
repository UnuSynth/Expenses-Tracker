//
//  CategoryModel.swift
//  ExpensesTrackerPackage
//

import SwiftUI
import SwiftData

private struct ColorComponents: Codable, Equatable {
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

@Model
public final class CategoryModel {
    @Attribute(.unique)
    public var name: String
    public var displayName: String
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
        displayName: String,
        icon: String,
        color: Color,
        isCustom: Bool = false,
        sortOrder: Int = 0
    ) {
        self.name = name
        self.displayName = displayName
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
        && lhs.displayName == rhs.displayName
        && lhs.icon == rhs.icon
        && lhs.colorComponents == rhs.colorComponents
    }
}
