//
//  CategoriesSettingsViewModel+Impl.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 9/6/26.
//

import Foundation

@Observable
@MainActor
final class CategoriesSettingsViewModelImpl: CategoriesSettingsViewModel {
    private(set) var categories: [ExpenseModel.Category] = ExpenseModel.Category.allCases

    private let repository: ExpensesRepositoryProtocol

    init(repository: ExpensesRepositoryProtocol) {
        self.repository = repository
    }

    func countForCategory(_ category: ExpenseModel.Category) -> Int {
        repository.getCount(in: category)
    }

    func deleteCategories(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }

    func moveCategories(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
    }
}

@Observable
@MainActor
final class CategoriesSettingsViewModelMock: CategoriesSettingsViewModel {
    private(set) var categories: [ExpenseModel.Category] = ExpenseModel.Category.allCases

    func countForCategory(_ category: ExpenseModel.Category) -> Int { 0 }
    func deleteCategories(at offsets: IndexSet) { categories.remove(atOffsets: offsets) }
    func moveCategories(from source: IndexSet, to destination: Int) { categories.move(fromOffsets: source, toOffset: destination) }
}
