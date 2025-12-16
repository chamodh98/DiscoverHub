//
//  APIClient.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation


final class APIClient {
    static let shared = APIClient()
    
    func request<T: Decodable>(_ endpont: Endpoint) async throws -> T {
        let request = try endpont.buildRequest()
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.apiError(http.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
