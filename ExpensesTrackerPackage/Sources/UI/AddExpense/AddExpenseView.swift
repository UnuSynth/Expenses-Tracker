//
//  AddExpenseView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 17/2/26.
//

import SwiftUI

struct AddExpenseView: View {
    private enum FocusField {
        case amount
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: AddExpenseViewModel
    @FocusState private var focus: FocusField?
    
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            form
                .task { focus = .amount }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if #available(iOS 26.0, *) {
                            Button(role: .close) {
                                dismiss()
                            }
                        } else {
                            Button("Close", systemImage: "xmark") {
                                dismiss()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        let confirmAction = {
                            viewModel.saveExpense()
                            dismiss()
                        }
                        
                        if #available(iOS 26.0, *) {
                            Button(
                                role: .confirm,
                                action: confirmAction
                            )
                            .disabled(!viewModel.isValid)
                        } else {
                            Button(
                                "Done",
                                systemImage: "checkmark",
                                action: confirmAction
                            )
                            .disabled(!viewModel.isValid)
                        }
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
                        .focused($focus, equals: .amount)
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
