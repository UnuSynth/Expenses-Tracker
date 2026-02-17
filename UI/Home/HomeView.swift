//
//  HomeView.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 10/2/26.
//

import SwiftUI

struct HomeView: View {
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
    }
}

#Preview {
    HomeView()
}
