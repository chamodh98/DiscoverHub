//
//  HomeViewModel.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // Child ViewModels
    @Published var newsViewModel: NewsViewModel
    @Published var weatherViewModel: WeatherViewModel
    @Published var currencyViewModel: CurrencyViewModel
    @Published var githubViewModel: GitHubViewModel
    
    // Quick currency rates (1 USD to...)
    @Published var cnyRate: String = "..."
    @Published var gbpRate: String = "..."
    @Published var jpyRate: String = "..."
    
    // Overall loading state
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.newsViewModel = NewsViewModel()
        self.weatherViewModel = WeatherViewModel()
        self.currencyViewModel = CurrencyViewModel()
        self.githubViewModel = GitHubViewModel()
        
        setupLoadingObserver()
        loadAllData()
    }
    
    private func setupLoadingObserver() {
        // Monitor all loading states
        Publishers.CombineLatest4(
            newsViewModel.$isLoading,
            weatherViewModel.$isLoading,
            currencyViewModel.$isLoading,
            githubViewModel.$isLoading
        )
        .map { newsLoading, weatherLoading, currencyLoading, githubLoading in
            newsLoading || weatherLoading || currencyLoading || githubLoading
        }
        .assign(to: &$isLoading)
    }
    
    func loadAllData() {
        // Trigger data fetch for all modules
        newsViewModel.refresh()
        weatherViewModel.loadWeather()
        
        // Set default currency conversion (USD to EUR)
        currencyViewModel.fromCurrency = .USD
        currencyViewModel.toCurrency = .EUR
        currencyViewModel.amount = "1"
        
        githubViewModel.refresh()
        
        // Load quick currency rates
        loadQuickCurrencyRates()
    }
    
    func refresh() {
        loadAllData()
    }
    
    // Helper computed properties for quick access
    var topNews: [NewsArticle] {
        Array(newsViewModel.articles.prefix(3))
    }
    
    var topRepos: [GitHubRepo] {
        Array(githubViewModel.repositories.prefix(3))
    }
    
    var currentWeather: CurrentWeather? {
        weatherViewModel.weather
    }
    
    var hasAnyData: Bool {
        !newsViewModel.articles.isEmpty ||
        weatherViewModel.weather != nil ||
        !githubViewModel.repositories.isEmpty ||
        currencyViewModel.convertedAmount != nil
    }
    
    // MARK: - Quick Currency Rates
    private func loadQuickCurrencyRates() {
        let service = CurrencyService()
        
        // Fetch CNY rate
        Task {
            do {
                let rate = try await service.convert(from: .USD, to: .CNY, amount: "1")
                self.cnyRate = String(format: "%.2f", rate)
            } catch {
                self.cnyRate = "--"
            }
        }
        
        // Fetch GBP rate
        Task {
            do {
                let rate = try await service.convert(from: .USD, to: .GBP, amount: "1")
                self.gbpRate = String(format: "%.2f", rate)
            } catch {
                self.gbpRate = "--"
            }
        }
        
        // Fetch JPY rate
        Task {
            do {
                let rate = try await service.convert(from: .USD, to: .JPY, amount: "1")
                self.jpyRate = String(format: "%.2f", rate)
            } catch {
                self.jpyRate = "--"
            }
        }
    }
}
