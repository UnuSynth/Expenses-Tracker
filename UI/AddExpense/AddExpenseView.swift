//
//  AddExpenseView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var date: Date = .now
    @State private var time: Date = .now
    @State private var amount: String = ""
    @State private var category: ExpenseModel.Category = .groceries
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            form.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var form: some View {
        Form {
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date
            )
            
            DatePicker(
                "Time",
                selection: $time,
                displayedComponents: .hourAndMinute
            )
            
            LabeledContent {
                TextField("", text: $amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            } label: {
                Text("Amount")
            }
            
            Picker("Category", selection: $category) {
                ForEach(ExpenseModel.Category.allCases) { category in
                    Text(category.displayName)
                        .tag(category)
                }
            }
            .pickerStyle(.automatic)
            
            LabeledContent {
                TextField("", text: $notes)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(5...10)
            } label: {
                Text("Notes")
            }
        }
    }
}

#Preview {
    AddExpenseView()
}
