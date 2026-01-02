//
//  GitHubViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

import Combine

@MainActor
final class GitHubViewModel: ObservableObject {
    @Published var repositories: [GitHubRepo] = []
    @Published var searchText: String = "swiftui"
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    // Combine Inputs
    let refreshTrigger = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let service: GitHubServiceProtocol
    
    init(service: GitHubServiceProtocol = GitHubService()) {
        self.service = service
        setupPipeline()
    }
    
    private func setupPipeline() {
        // Debounced search input
        let searchInput = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
        
        // Refresh triggers just emit current search text
        let refreshInput = refreshTrigger
            .map { [unowned self] in self.searchText }
        
        // Merge and execute
        Publishers.Merge(searchInput, refreshInput)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.errorMessage = nil
            })
            .sink { [weak self] query in
                Task { [weak self] in
                    await self?.search(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func search(query: String) async {
        guard !query.isEmpty else {
            self.repositories = []
            self.isLoading = false
            return
        }
        
        do {
            self.repositories = try await service.searchRepositories(query: query)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    // Public synchronous trigger for Refreshable
    func refresh() {
        refreshTrigger.send()
    }
    
    // Kept for manual refresh if needed, but internally uses pipeline
    func fetchRepositories() {
        refresh()
    }
}
