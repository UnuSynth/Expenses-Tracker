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
    @State private var showCalendar = false
    
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 8) {
                Spacer()
                Button("\(viewModel.date.relativeLabel), \(viewModel.date.formatted(.dateTime.hour().minute()))", systemImage: "calendar") {
                    showCalendar = true
                }
                .popover(
                    isPresented: $showCalendar,
                    arrowEdge: .top
                ) {
                    DatePicker(
                        "",
                        selection: $viewModel.date,
                        in: viewModel.datesRange
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
                    currency: .current,
                    text: $viewModel.amountString
                )
                
                CategorySelector(
                    categories: viewModel.categories,
                    selection: $viewModel.category
                )
                
                HStack(spacing: 6) {
                    Image(systemName: "pencil")
                    TextField("Add a note", text: $viewModel.notes)
                        .lineLimit(1...2)
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .modifier(CapsuleButtonBehaviorModifier())
                }
                
                NumberPad(
                    text: $viewModel.amountString
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
