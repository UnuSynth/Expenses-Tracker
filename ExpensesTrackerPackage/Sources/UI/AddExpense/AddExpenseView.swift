//
//  AddExpenseView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: AddExpenseViewModel
    
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            form
                .toolbar {
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
                        .disabled(!viewModel.isValid)
                    }
                }
        }
    }
    
    private var form: some View {
        Form {
            Section {
                DatePicker(
                    "Date",
                    selection: $viewModel.date,
                    in: viewModel.datesRange,
                    displayedComponents: .date
                )
                
                DatePicker(
                    "Time",
                    selection: $viewModel.date,
                    displayedComponents: .hourAndMinute
                )
                
                LabeledContent {
                    TextField("", text: $viewModel.amountString)
                        .foregroundStyle(.primary)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Amount")
                }
                
                Picker("Category", selection: $viewModel.category) {
                    ForEach(viewModel.categories) { category in
                        Text(category.displayName)
                            .tag(category)
                    }
                }
                .pickerStyle(.menu)
                
                LabeledContent {
                    TextEditor(text: $viewModel.notes)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Notes")
                }
            }
            header: {
                header
            }
        }
        .foregroundStyle(.secondary)
        .font(.callout)
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
}

#Preview {
    AddExpenseView(
        viewModel: AddExpenseMockViewModel()
    )
}
