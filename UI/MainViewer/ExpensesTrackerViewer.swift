//
//  ExpensesTrackerViewer.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 9/2/26.
//

import SwiftUI

struct ExpensesTrackerViewer: View {
    @State private var search: String = ""
    var body: some View {
        TabView {
            Tab("First", systemImage: "1.circle") {
//                NavigationStack {
//                    HomeView()
//                        .padding(.horizontal, 16)
//                        .background(.background.secondary)
//                        .navigationTitle("Expenses Tracker")
//                }
            }
            
            Tab("Second", systemImage: "2.circle") {
                
            }
            
            Tab("", systemImage: "plus", role: .search) {
                NavigationStack {
                    
                }
            }
        }
        .searchable(text: $search)
    }
}

#Preview {
    ExpensesTrackerViewer()
}
