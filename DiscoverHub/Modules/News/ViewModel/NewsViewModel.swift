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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var service = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe searchQuery with debounce using Combine
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] q in
                Task {
                    if q.isEmpty {
                        await self?.loadTopHeadlines()
                    } else {
                        await self?.search(q)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadTopHeadlines() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await service.fetchTopHeadlines()
            articles = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func search(_ q: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await service.searchNews(query: q)
            articles = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
