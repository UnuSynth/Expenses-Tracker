//
//  HomeViewExpensesTodayCell.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 16/2/26.
//

import SwiftUI

struct HomeViewExpensesTodayCell: View {
    private var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            upperSection
            Spacer(minLength: 40)
            lowerSection
        }
        .padding(16)
    }
    
    private var upperSection: some View {
        HStack {
            Text("Expenses today")
                .font(.subheadline.bold())
            Spacer()
            HStack(spacing: 8) {
                Text(model.timeStr)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.secondary)
            }
            
        }
    }
    
    private var lowerSection: some View {
        HStack() {
            Text(model.amount.description)
                .font(.title2.bold())
            Text(model.currency)
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
    }
}
