//
//  NewsViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-11.
//

import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    private var service: NewsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Refresh Trigger
    let refreshTrigger = PassthroughSubject<Void, Never>()
    
    init(service: NewsServiceProtocol = NewsService()) {
        self.service = service
        
        // Unified Pipeline: Merge Search and Refresh
        let searchInput = $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let refreshInput = refreshTrigger
            .map { [unowned self] in self.searchQuery }
        
        Publishers.Merge(searchInput, refreshInput)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.errorMessage = nil
            })
            .sink { [weak self] q in
                Task { [weak self] in
                    if q.isEmpty {
                        await self?.loadTopHeadlines()
                    } else {
                        await self?.search(q)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadTopHeadlines() async {
        do {
            let result = try await service.fetchTopHeadlines()
            self.articles = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    private func search(_ q: String) async {
        do {
            let result = try await service.searchNews(query: q)
            self.articles = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    func refresh() {
        refreshTrigger.send()
    }
}
