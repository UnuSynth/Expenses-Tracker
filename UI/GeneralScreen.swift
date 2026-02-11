//
//  GeneralScreen.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI

struct GeneralScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                TotalExpensesView()
                    .navigationTitle("Expenses")
            }
            .padding()
        }
    }
}

extension GeneralScreen {
    
}

#Preview {
    GeneralScreen()
}
