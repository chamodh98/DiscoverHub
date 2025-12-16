//
//  APIService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

protocol APIService {
    associatedtype ResponseType: Decodable
    func execute() async throws -> ResponseType
}
