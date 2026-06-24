//
//  AddCategoryView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 20/6/26.
//

import SwiftData
import SwiftUI

struct AddCategoryView: View {
    let nextSortOrder: Int

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var displayName = ""
    @State private var selectedIcon = "tag.fill"
    @State private var selectedColor = Color.blue
    @State private var showDuplicateAlert = false

    private let icons = [
        "tag.fill", "cart.fill", "fork.knife", "car.fill", "bag.fill",
        "heart.fill", "building.2.fill", "popcorn.fill", "lightbulb.fill",
        "airplane", "ellipsis.circle.fill", "gift.fill", "book.fill",
        "dumbbell.fill", "pawprint.fill", "music.note", "camera.fill",
        "laptopcomputer", "phone.fill", "house.fill", "tv.fill",
        "leaf.fill", "star.fill", "creditcard.fill", "banknote.fill",
        "gamecontroller.fill", "bicycle", "bus.fill", "fuelpump.fill",
        "pill.fill", "stethoscope", "scissors", "wrench.fill",
        "paintbrush.fill", "hammer.fill", "figure.walk"
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 6)

    private var trimmedName: String {
        displayName.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(.name) {
                    TextField("Category name", text: $displayName)
                }

                Section(.color) {
                    ColorPicker(.color, selection: $selectedColor, supportsOpacity: false)
                }

                Section(.icon) {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(icons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedIcon == icon ? selectedColor : Color.secondary.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: icon)
                                        .foregroundStyle(selectedIcon == icon ? .white : .primary)
                                        .font(.system(size: 18))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(.newCategory)
            .navigationBarTitleDisplayMode(.inline)
            .alert(.duplicateCategory, isPresented: $showDuplicateAlert) {
                Button(.ok, role: .cancel) {}
            } message: {
                Text("A category named \"\(trimmedName)\" already exists.")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if #available(iOS 26.0, *) {
                        Button(role: .close) {
                            dismiss()
                        }
                    } else {
                        Button(.close) {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if #available(iOS 26.0, *) {
                        Button(role: .confirm) {
                            addCategory()
                        }
                        .disabled(trimmedName.isEmpty)
                    } else {
                        Button(.done) {
                            addCategory()
                            dismiss()
                        }
                        .disabled(trimmedName.isEmpty)
                    }
                }
            }
        }
    }

    private func addCategory() {
        guard !trimmedName.isEmpty else { return }
        let category = CategoryModel(
            name: trimmedName,
            icon: selectedIcon,
            color: selectedColor,
            isCustom: true,
            sortOrder: nextSortOrder
        )
        
        do {
            try context.transaction {
                context.insert(category)
            }
        } catch SwiftDataError.modelValidationFailure {
            validateCategoryName()
        } catch {
            debugPrint(error)
        }
    }
    
    private func validateCategoryName() {
        let name = trimmedName
        let descriptor: FetchDescriptor<CategoryModel> = .init(
            predicate: #Predicate { $0.name == name }
        )

        if (try? context.fetchCount(descriptor)) ?? 0 > 0 {
            showDuplicateAlert = true
        }
    }
}
