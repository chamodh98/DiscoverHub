//
//  WeatherCard.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import SwiftUI

struct WeatherCard: View {
    let weather: CurrentWeather
    @Environment(\.colorScheme) var colorScheme
    
    private var info: WeatherInfo {
        WeatherInfo.from(code: weather.weatherCode, isNight: false)
    }
    
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                // Header with Location and Date
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text("Colombo, LK")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text(Date().toFormattedDate()) 
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    // Weather Badge
                    HStack(spacing: 4) {
                        Image(systemName: info.icon)
                        Text(info.description)
                            .fontWeight(.medium)
                    }
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .foregroundColor(.white)
                
                // Main Info
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(Int(round(weather.temperature)))°")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                        
                        Text(info.description)
                            .font(.title3)
                            .fontWeight(.medium)
                            .opacity(0.9)
                    }
                    
                    Spacer()
                    
                    Image(systemName: info.icon)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 80))
                        .shadow(radius: 10)
                }
                .foregroundColor(.white)
            }
        }
        .background(
            LinearGradient(
                colors: [info.color.opacity(0.8), info.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .appShadow(AppShadows.card)
    }
}

#Preview {
    WeatherCard(
        weather: CurrentWeather(
            temperature: 28.4,
            windSpeed: 12.3,
            weatherCode: 1,
            humidity: 65,
            pressure: 1012
        )
    )
    .padding()
}
