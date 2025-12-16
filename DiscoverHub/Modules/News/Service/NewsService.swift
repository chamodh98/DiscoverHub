//
//  NewsService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-11.
//

import Foundation

//enum NewsServiceError: Error {
//    case invalidURL
//    case invalidResponse
//}

protocol NewsServiceProtocol {
    func fetchTopHeadlines() async throws -> [NewsArticle]
    func searchNews(query: String) async throws -> [NewsArticle]
}

//class NewsService {
//    private let apiKey = "88eefc6dcd9a46f6b46c82e8f030dc0c"
//    
//    func fetchTopHeadlines(country: String = "us") async throws -> [NewsArticle] {
//        let urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&language=en&apiKey=\(apiKey)"
//        guard let url = URL(string: urlString) else {
//            throw NewsServiceError.invalidURL
//        }
//        
//        let (data, resp) = try await URLSession.shared.data(from: url)
//        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
//            throw NewsServiceError.invalidResponse
//        }
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        let newsResp = try decoder.decode(NewsResponse.self, from: data)
//        return newsResp.articles
//    }
//    
//    func searchNews(query: String) async throws -> [NewsArticle] {
//        let escaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
//        let urlString = "https://newsapi.org/v2/everything?q=\(escaped)&sortBy=publishedAt&language=en&apiKey=\(apiKey)"
//        guard let url = URL(string: urlString) else {
//            throw NewsServiceError.invalidURL
//        }
//        
//        let (data, resp) = try await URLSession.shared.data(from: url)
//        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
//            throw NewsServiceError.invalidResponse
//        }
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        let newsResp = try decoder.decode(NewsResponse.self, from: data)
//        return newsResp.articles
//    }
//}


final class NewsService: NewsServiceProtocol {
    
    private let client = APIClient.shared
    
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
