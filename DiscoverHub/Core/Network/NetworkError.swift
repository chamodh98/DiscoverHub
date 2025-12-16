//
//  NetworkError.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case apiError(Int)
}
