//
//  ExpensesTrackerViewer.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI

public struct ExpensesTrackerViewer: View {
    public init() { }
    
    public var body: some View {
        NavigationStack {
            HomeView(viewModel: SharedContainer.resolve(HomeViewModel.self) ?? HomeMockViewModel())
                .navigationTitle("Expenses Tracker AI")
        }
    }
}

#Preview {
    ExpensesTrackerViewer()
}
