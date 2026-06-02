//
//  SearchModifier.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 30/5/26.
//

import SwiftUI

struct SearchBehaviorModifier: ViewModifier {
    @Binding private var searchText: String
    @State private var isSearchActive = false
    @FocusState private var isFieldFocused: Bool
    @Environment(\.isSearching) private var isSearching: Bool
    
    init(searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .searchable(
                    text: $searchText,
                    placement: .automatic,
                    prompt: "Search expenses"
                )
                .searchToolbarBehavior(.minimize)
                .toolbar {
                    DefaultToolbarItem(
                        kind: .search,
                        placement: .bottomBar
                    )
                }
        } else {
            if isSearchActive {
                content
                    .searchable(
                        text: $searchText,
                        isPresented: $isSearchActive,
                        placement: .automatic,
                        prompt: "Search expenses"
                    )
            } else {
                content
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Search", systemImage: "magnifyingglass") {
                                withAnimation {
                                    isSearchActive = true
                                }
                            }
                        }
                    }
            }
        }
    }
}
