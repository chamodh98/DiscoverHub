//
//  NetworkManager.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

final class NetworkManager: APIClient {
    static let shared = NetworkManager()
    private init() {}
    
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
