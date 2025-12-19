//
//  NewsService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-11.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchTopHeadlines() async throws -> [NewsArticle]
    func searchNews(query: String) async throws -> [NewsArticle]
}


final class NewsService: NewsServiceProtocol {
    
    private let client: APIClient
    
    init(client: APIClient = NetworkManager.shared) {
        self.client = client
    }
    
    func fetchTopHeadlines() async throws -> [NewsArticle] {
        let endPoint = NewsEndpoint.topHeadlines(country: "us").endpoint
        let response: NewsResponse = try await client.request(endPoint)
        return response.articles
    }
    
    func searchNews(query: String) async throws -> [NewsArticle] {
        let endPoint = NewsEndpoint.search(query: query).endpoint
        let response: NewsResponse = try await client.request(endPoint)
        return response.articles
    }
    
}
