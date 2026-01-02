//
//  WeatherViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-19.
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let loadTrigger = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
        setupPipeline()
    }
    
    private func setupPipeline() {
        loadTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.errorMessage = nil
            })
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.fetchWeather()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchWeather() async {
        do {
            let response = try await service.fetchWeather()
            self.weather = response.current
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    // Public trigger
    func loadWeather() {
        loadTrigger.send()
    }
}
