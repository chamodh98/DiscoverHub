//
//  GitHubSearchResponse.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import Foundation

struct GitHubSearchResponse: Decodable {
    let items: [GitHubRepo]
}
