//
//  WeatherInfo.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-31.
//

import SwiftUI

struct WeatherInfo {
    let description: String
    let icon: String
    let color: Color
    
    // Mapping WMO Weather interpretation codes (https://open-meteo.com/en/docs)
    static func from(code: Int, isNight: Bool = false) -> WeatherInfo {
        switch code {
        case 0:
            return WeatherInfo(
                description: "Clear Sky",
                icon: isNight ? "moon.stars.fill" : "sun.max.fill",
                color: .orange
            )
        case 1, 2, 3:
            return WeatherInfo(
                description: "Partly Cloudy",
                icon: isNight ? "cloud.moon.fill" : "cloud.sun.fill",
                color: .blue
            )
        case 45, 48:
            return WeatherInfo(
                description: "Foggy",
                icon: "cloud.fog.fill",
                color: .gray
            )
        case 51, 53, 55:
            return WeatherInfo(
                description: "Drizzle",
                icon: "cloud.drizzle.fill",
                color: .cyan
            )
        case 61, 63, 65:
            return WeatherInfo(
                description: "Rain",
                icon: "cloud.rain.fill",
                color: .blue
            )
        case 71, 73, 75:
            return WeatherInfo(
                description: "Snow",
                icon: "snowflake",
                color: .cyan
            )
        case 77:
            return WeatherInfo(
                description: "Snow Grains",
                icon: "snowflake",
                color: .cyan
            )
        case 80, 81, 82:
            return WeatherInfo(
                description: "Rain Showers",
                icon: "cloud.heavyrain.fill",
                color: .blue
            )
        case 85, 86:
            return WeatherInfo(
                description: "Snow Showers",
                icon: "cloud.snow.fill",
                color: .cyan
            )
        case 95:
            return WeatherInfo(
                description: "Thunderstorm",
                icon: "cloud.bolt.fill",
                color: .yellow
            )
        case 96, 99:
            return WeatherInfo(
                description: "Thunderstorm with Hail",
                icon: "cloud.bolt.rain.fill",
                color: .purple
            )
        default:
            return WeatherInfo(
                description: "Unknown",
                icon: "questionmark.circle",
                color: .gray
            )
        }
    }
    
    // Adaptive color helper
    func adaptiveColor(for colorScheme: ColorScheme) -> Color {
        return color
    }
}
