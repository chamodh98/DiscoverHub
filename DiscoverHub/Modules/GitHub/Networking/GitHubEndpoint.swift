//
//  GitHubEndpoint.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

enum GitHubEndpoint {
    static func searchRepositories(query: String) -> Endpoint {
        Endpoint(
            baseURL: "https://api.github.com",
            path: "/search/repositories",
            method: .get,
            query: [
                "q": query,
                "sort": "stars",
                "order": "desc"
            ],
            headers: [
                "Accept": "application/vnd.github+json",
                "User-Agent": "DiscoverHub-iOS-App"
            ]
        )
    }
}
