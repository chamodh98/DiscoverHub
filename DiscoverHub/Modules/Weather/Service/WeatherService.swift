//
//  WeatherService.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather() async throws -> WeatherResponse
}

final class WeatherService: WeatherServiceProtocol {
    
    private let client: APIClient
    
    init(client: APIClient = NetworkManager.shared) {
        self.client = client
    }
    
    func fetchWeather() async throws -> WeatherResponse {
        let endpoint = WeatherEndpoint.currentWeather()
        return try await client.request(endpoint)
    }
}
