//
//  WeatherViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchWeather()
            self.weather = response.current_weather
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
