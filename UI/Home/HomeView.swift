//
//  HomeView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 10/2/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showingAddExpenseSheet = false

    var body: some View {
        ScrollView {
            HomeViewExpensesTodayCell()
                .background(
                    .white,
                    in: .rect(
                        corners: .concentric(
                            minimum: 16
                        )
                    )
                )
        }
        .toolbar {
            ToolbarItemGroup(
                placement: .bottomBar
            ) {
                Button(
                    "",
                    systemImage: "plus",
                    action:  {
                        showingAddExpenseSheet = true
                    }
                )
            }
        }
        .sheet(isPresented: $showingAddExpenseSheet) {
            AddExpenseView()
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    HomeView()
}
