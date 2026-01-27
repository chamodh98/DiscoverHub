//
//  MockWeatherService.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Foundation
@testable import DiscoverHub

/// Mock implementation of WeatherServiceProtocol for testing
class MockWeatherService: WeatherServiceProtocol {
    
    // Test configuration
    var weatherToReturn: WeatherResponse?
    var errorToThrow: Error?
    var shouldDelay: Bool = false
    var delayDuration: TimeInterval = 0.1
    
    // Tracking calls
    var fetchWeatherCalled = false
    
    func fetchWeather() async throws -> WeatherResponse {
        fetchWeatherCalled = true
        
        if shouldDelay {
            try? await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        guard let weather = weatherToReturn else {
            throw TestFixtures.TestError.networkError
        }
        
        return weather
    }
    
    func reset() {
        weatherToReturn = nil
        errorToThrow = nil
        shouldDelay = false
        fetchWeatherCalled = false
    }
}
