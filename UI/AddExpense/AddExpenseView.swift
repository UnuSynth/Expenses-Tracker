//
//  AddExpenseView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: ViewModel
    
    init(viewModel: ViewModel = ViewModelImplementation()) {
        self.viewModel = viewModel
    }
    
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
                        viewModel.saveExpense()
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
                selection: $viewModel.date,
                displayedComponents: .date
            )
            
            DatePicker(
                "Time",
                selection: $viewModel.date,
                displayedComponents: .hourAndMinute
            )
            
            LabeledContent {
                TextField("", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            } label: {
                Text("Amount")
            }
            
            Picker("Category", selection: $viewModel.category) {
                ForEach(viewModel.getCategories()) { category in
                    Text(category.displayName)
                        .tag(category)
                }
            }
            .pickerStyle(.automatic)
            
            LabeledContent {
                TextField("", text: $viewModel.notes)
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
