//
//  ExpensesTrackerViewer.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI

struct ExpensesTrackerViewer: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .padding(.horizontal, 16)
                .background(.background.secondary)
                .navigationTitle("Expenses Tracker")
        }
    }
}

#Preview {
    ExpensesTrackerViewer()
}
