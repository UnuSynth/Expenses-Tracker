//
//  ExpensesTrackerViewer.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI

public struct ExpensesTrackerViewer: View {
    @AppStorage(AppStorageKeys.languageCode.key) private var languageCode: String = "en"

    public init() { }

    public var body: some View {
        NavigationStack {
            HomeView(viewModel: HomeViewModelImpl())
                .navigationTitle(.expensesTrackerAi)
                .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.locale, Locale(identifier: languageCode))
    }
}

#Preview {
    ExpensesTrackerViewer()
}
