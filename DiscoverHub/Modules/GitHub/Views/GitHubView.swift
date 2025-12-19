//
//  GitHubView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct GitHubView: View {
    @StateObject private var viewModel = GitHubViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading repositories...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.repositories) { repo in
                        GitHubRepoCard(repo: repo)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("GitHub")
            .searchable(text: $viewModel.searchText)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.fetchRepositories()
                }
            }
            .task {
                await viewModel.fetchRepositories()
            }
        }
    }
}

#Preview {
    GitHubView()
}
