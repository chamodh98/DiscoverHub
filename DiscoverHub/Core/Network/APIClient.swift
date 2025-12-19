//
//  APIClient.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ endpont: Endpoint) async throws -> T
}
