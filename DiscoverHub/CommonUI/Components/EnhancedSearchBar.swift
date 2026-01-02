//
//  EnhancedSearchBar.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-03.
//

import SwiftUI

struct EnhancedSearchBar: View {
    @Binding var searchQuery: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? AppColors.primary : .secondary)
                .font(.system(size: 16))
            
            TextField("Search...", text: $searchQuery)
                .focused($isFocused)
            
            if !searchQuery.isEmpty {
                Button(action: {
                    searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? AppColors.primary : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: searchQuery.isEmpty)
    }
}
