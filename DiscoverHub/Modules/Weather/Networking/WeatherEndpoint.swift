//
//  WeatherEndpoint.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import Foundation

enum WeatherEndpoint {
    static func currentWeather() -> Endpoint {
        Endpoint(
            baseURL: "https://api.open-meteo.com",
            path: "/v1/forecast",
            method: .get,
            query: [
                "latitude": "6.9271",
                "longitude": "79.8612",
                "current_weather": "true"
            ],
            headers: nil
        )
    }
}
