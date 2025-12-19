//
//  WeatherView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Weather")
                .task {
                    await viewModel.loadWeather()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Fetching weather..")
        } else if let weather = viewModel.weather {
            WeatherCard(weather: weather)
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
        } else {
            Text("No weather data")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    WeatherView()
}
