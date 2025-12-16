//
//  Endpoint.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

struct Endpoint {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let query: [String: String]?
    let headers: [String: String]?
    
    func buildRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        if let query = query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
