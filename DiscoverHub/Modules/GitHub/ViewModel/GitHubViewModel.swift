//
//  GitHubViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

@MainActor
final class GitHubViewModel: ObservableObject {
    @Published var repositories: [GitHubRepo] = []
    @Published var searchText: String = "swiftui"
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: GitHubServiceProtocol
    
    init(service: GitHubServiceProtocol = GitHubService()) {
        self.service = service
    }
    
    func fetchRepositories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            repositories = try await service.searchRepositories(query: searchText)
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
        
        isLoading = false
    }
}
