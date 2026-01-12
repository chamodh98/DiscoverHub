//
//  WeatherView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Adaptive background color based on theme
                (colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
                    .ignoresSafeArea()
                
                content
            }
            .navigationTitle("Weather")
            .task {
                viewModel.loadWeather()
            }
            .refreshable {
                viewModel.loadWeather()
            }
        }
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.weather == nil {
            SkeletonWeatherView()
        } else if let error = viewModel.errorMessage {
            ErrorStateView(
                errorMessage: error,
                retryAction: {
                    viewModel.loadWeather()
                }
            )
        } else if let weather = viewModel.weather {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Hero Card
                    WeatherCard(weather: weather)
                        .padding(.top, AppSpacing.md)
                    
                    // Details Grid
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Current Details")
                            .font(.headline)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 4)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: AppSpacing.md) {
                            WeatherDetailItem(
                                icon: "wind",
                                title: "Wind Speed",
                                value: "\(String(format: "%.1f", weather.windSpeed)) km/h",
                                color: .blue
                            )
                            
                            WeatherDetailItem(
                                icon: "thermometer",
                                title: "Temperature",
                                value: "\(String(format: "%.1f", weather.temperature))°C",
                                color: .orange
                            )
                            
                            WeatherDetailItem(
                                icon: "drop.fill",
                                title: "Humidity",
                                value: "\(weather.humidity)%",
                                color: .teal
                            )
                            
                            WeatherDetailItem(
                                icon: "barometer",
                                title: "Pressure",
                                value: "\(String(format: "%.0f", weather.pressure)) hPa",
                                color: .purple
                            )
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
        } else {
            EmptyStateView(
                icon: "cloud.sun",
                title: "No Weather Data",
                message: "Unable to load weather information.",
                actionTitle: "Reload",
                action: { viewModel.loadWeather() }
            )
        }
    }
}

#Preview {
    WeatherView()
}
