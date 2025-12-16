//
//  NewsEndpoint.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-17.
//

import Foundation

enum NewsEndpoint {
    case topHeadlines(country: String)
    case search(query: String)
    
    var endpoint: Endpoint {
        Endpoint(baseURL: "https://newsapi.org",
                 path: path,
                 method: .get,
                 query: queryItems,
                 headers: [
                    "X-Api-Key": NewsConfig.apiKey
                 ]
        )
    }
}

extension NewsEndpoint {
    
    private var path: String {
        switch self {
        case .topHeadlines:
            return "/v2/top-headlines"
        case .search:
            return "/v2/everything"
        }
    }
    
    private var queryItems: [String: String]? {
        switch self {
        case .topHeadlines(let country):
            return [
                "country": country,
                "language": "en"
            ]
        case .search(let query):
            return [
                "q": query,
                "sortBy": "publishedAt",
                "language": "en"
            ]
        }
    }
}
