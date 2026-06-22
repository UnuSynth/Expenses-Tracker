//
//  AddExpenseView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

import SwiftUI
import SwiftData

struct ExpenseEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: \CategoryModel.sortOrder) private var categories: [CategoryModel]
    @AppStorage("selectedCurrency") private var selectedCurrencyRaw: String = Currency.usd.rawValue
    @Environment(\.modelContext) private var context
    
    @State private var date: Date = .now
    @State private var amountString: String = ""
    @State private var category: CategoryModel? = nil
    @State private var notes: String = ""
    @State private var showCalendar = false
    
    private var expense: ExpenseDBModel?
    
    private var datesRange: ClosedRange<Date> {
        // a date range between 20 years ago and now
        Date.now.addingTimeInterval(-1*3600*24*365*20)...Date.now
    }
    
    private var amountDouble: Double? {
        amountString.toDouble()
    }

    private var isValid: Bool {
        amountString.isEmpty == false
        && amountDouble != nil
        && amountDouble != 0
        && category != nil
    }
    
    init(expense: ExpenseDBModel? = nil) {
        self.expense = expense
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 8) {
                Spacer()
                Button("\(date.relativeLabel), \(date.formatted(.dateTime.hour().minute()))", systemImage: "calendar") {
                    showCalendar = true
                }
                .popover(
                    isPresented: $showCalendar,
                    arrowEdge: .top
                ) {
                    DatePicker(
                        "",
                        selection: $date,
                        in: datesRange
                    )
                    .datePickerStyle(.wheel)
                    .presentationCompactAdaptation(.popover)
                }
                .font(.subheadline.bold())
                .foregroundStyle(.indigo)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .modifier(CapsuleButtonBehaviorModifier())
                
                CurrencyTextField(
                    currency: .initialize(rawValue: selectedCurrencyRaw),
                    text: $amountString
                )
                
                CategorySelector(
                    categories: categories,
                    selection: $category
                )
                
                TextField("Add a note", text: $notes)
                    .safeAreaInset(edge: .leading) {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                            .padding(.trailing, 4)
                    }
                    .lineLimit(1...2)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .modifier(CapsuleButtonBehaviorModifier())
                
                NumberPad(
                    text: $amountString
                )
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if #available(iOS 26.0, *) {
                        Button(role: .close) {
                            dismiss()
                        }
                    } else {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                
                if let expense {
                    ToolbarItem(placement: .destructiveAction) {
                        Button(role: .destructive) {
                            context.delete(expense)
                            dismiss()
                        } label: {
                            Label("Delete expense", systemImage: "trash")
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    let confirmAction = {
                        if let expense {
                            editExpense(expense)
                        } else {
                            saveExpense()
                        }
                        
                        if context.hasChanges { try? context.save() }
                        
                        dismiss()
                    }
                    
                    if #available(iOS 26.0, *) {
                        Button(
                            role: .confirm,
                            action: confirmAction
                        )
                        .disabled(!isValid)
                    } else {
                        Button(
                            "Done",
                            action: confirmAction
                        )
                        .disabled(!isValid)
                    }
                }
            }
        }
        .onAppear {
            guard let expense else { return }
            date = expense.date
            amountString = expense.amount.formattedDescription
            category = expense.category
            notes = expense.notes?.desc ?? ""
        }
    }
    
    private var header: some View {
        VStack(alignment: .center) {
            Image(systemName: "creditcard.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 48)
                .accessibilityHidden(true)
                .padding(.bottom, 16)
            
            
            Text("Expense")
                .font(.title.bold())
                .foregroundStyle(.primary)
            
        }
        .containerRelativeFrame(.horizontal)
        .padding()
    }
    
    private func saveExpense() {
        guard let category else { return }
        
        let newExpense = ExpenseDBModel(
            date: date,
            amount: amountDouble ?? 0,
            category: category,
            notes: notes.isEmpty ? nil : .init(desc: notes)
        )
        
        context.insert(newExpense)
    }
    
    private func editExpense(_ expense: ExpenseDBModel) {
        guard let category else { return }
        
        if expense.date != date {
            expense.date = date
        }
        
        if expense.amount != (amountDouble ?? 0) {
            expense.amount = amountDouble ?? 0
        }
        
        if expense.category != category {
            expense.category = category
        }
        
        if notes != expense.notes?.desc {
            expense.notes = notes.isEmpty ? nil : .init(desc: notes)
        }
    }
}
