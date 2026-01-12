//
//  GitHubView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct GitHubView: View {
    @StateObject private var viewModel = GitHubViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    EnhancedSearchBar(searchQuery: $viewModel.searchText)
                        .padding(.horizontal, 16)
                        .padding(.top, AppSpacing.sm)
                        .padding(.bottom, AppSpacing.xs)
                    
                    Group {
                    if viewModel.isLoading {
                        SkeletonGitHubView()
                    } else if let error = viewModel.errorMessage {
                        ErrorStateView(
                            errorMessage: error,
                            retryAction: {
                                viewModel.refresh()
                            }
                        )
                    } else if viewModel.repositories.isEmpty {
                        EmptyStateView(
                            icon: "text.magnifyingglass",
                            title: "No Repositories Found",
                            message: "Try searching for a different keyword.",
                            actionTitle: "Refresh",
                            action: { viewModel.refresh() }
                        )
                    } else {
                        List(viewModel.repositories) { repo in
                            GitHubRepoCard(repo: repo)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .listStyle(.plain)
                        .scrollDismissesKeyboard(.immediately)
                        .refreshable {
                            viewModel.refresh()
                        }
                    }
                    }
                }
            }
            .navigationTitle("GitHub")
            .padding(.bottom, 90)
        }
    }
}

#Preview {
    GitHubView()
}
