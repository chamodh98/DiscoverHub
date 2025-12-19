//
//  WeatherCard.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import SwiftUI

struct WeatherCard: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white)
            
            Text("\(weather.temperature, specifier: "%.1f")°C")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
            
            Text("Wind: \(weather.windspeed, specifier: "%.1f") km/h")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    WeatherCard(
        weather: CurrentWeather(
            temperature: 28.4,
            windspeed: 12.3,
            weathercode: 1
        )
    )
}
