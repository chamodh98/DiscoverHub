//
//  WeatherResponse.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let windSpeed: Double
    let weatherCode: Int
    let humidity: Int
    let pressure: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature2M"
        case windSpeed = "windSpeed10M"
        case weatherCode
        case humidity = "relativeHumidity2M"
        case pressure = "surfacePressure"
    }
}
