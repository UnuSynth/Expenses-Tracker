//
//  PartnerLinkView.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 21/4/26.
//

import SwiftUI

struct PartnerLinkView: View {
    @Environment(\.dismiss) private var dismiss
    // Phase 3: replace with real partner state from CloudKit
    @State private var isLinked = false
    @State private var showUnlinkConfirmation = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                if isLinked {
                    linkedState
                } else {
                    unlinkedState
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationTitle("Partner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog("Remove partner?", isPresented: $showUnlinkConfirmation, titleVisibility: .visible) {
                Button("Remove Partner", role: .destructive) { isLinked = false }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private var unlinkedState: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 8) {
                Text("Share with a partner")
                    .font(.title3)
                    .bold()
                Text("Browse each other's spending.\nYour data stays yours.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                Button("Send Invite") {
                    // Phase 3: initiate CKShare
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.accentColor, in: .rect(cornerRadius: 12))

                Button("Enter Code") {
                    // Phase 3: enter invite code
                }
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
            }
        }
    }

    private var linkedState: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("Linked with Alex")
                    .font(.title3)
                    .bold()
                Text("Sharing since April 2026")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button("View Partner Spending") {}
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.accentColor, in: .rect(cornerRadius: 12))

                Button("Remove Partner") {
                    showUnlinkConfirmation = true
                }
                .font(.body)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, minHeight: 44)
            }
        }
    }
}

#Preview {
    PartnerLinkView()
}
