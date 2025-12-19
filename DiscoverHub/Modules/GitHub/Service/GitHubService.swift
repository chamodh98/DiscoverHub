//
//  GitHubService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

protocol GitHubServiceProtocol {
    func searchRepositories(query: String) async throws -> [GitHubRepo]
}

final class GitHubService: GitHubServiceProtocol {
    private let client: APIClient
    
    init(client: APIClient = NetworkManager.shared) {
        self.client = client
    }
    
    func searchRepositories(query: String) async throws -> [GitHubRepo] {
        let endpoint = GitHubEndpoint.searchRepositories(query: query)
        let response: GitHubSearchResponse = try await client.request(endpoint)
        return response.items
    }
}
