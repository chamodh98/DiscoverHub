//
//  HomeView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedTab: Tab
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Greeting Header
                    greetingHeader
                    
                    // Weather Summary Card
                    weatherSummaryCard
                    
                    // News Summary Card
                    newsSummaryCard
                    
                    // Currency Summary Card
                    currencySummaryCard
                    
                    // GitHub Summary Card
                    githubSummaryCard
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, 100) // Space for tab bar
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                viewModel.refresh()
            }
        }
    }
    
    // MARK: - Greeting Header
    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingMessage)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primary)
                
                Text("Here's your daily digest")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.top, AppSpacing.sm)
    }
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    // MARK: - News Summary Card
    private var newsSummaryCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                cardHeader(title: "Top Headlines", icon: "newspaper.fill") {
                    selectedTab = .news
                }
                
                if viewModel.newsViewModel.isLoading && viewModel.newsViewModel.articles.isEmpty {
                    SkeletonView()
                        .frame(height: 180)
                } else if let error = viewModel.newsViewModel.errorMessage {
                    errorView(message: error)
                } else if viewModel.topNews.isEmpty {
                    emptyStateView(message: "No news available")
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.topNews) { article in
                            newsRow(article: article)
                            if article.id != viewModel.topNews.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func newsRow(article: NewsArticle) -> some View {
        HStack(spacing: 12) {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: 70, height: 70)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(article.source.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Weather Summary Card
    private var weatherSummaryCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                cardHeader(title: "Current Weather", icon: "sun.max.fill") {
                    selectedTab = .weather
                }
                
                if viewModel.weatherViewModel.isLoading && viewModel.weatherViewModel.weather == nil {
                    SkeletonView()
                        .frame(height: 120)
                } else if let error = viewModel.weatherViewModel.errorMessage {
                    errorView(message: error)
                } else if let weather = viewModel.currentWeather {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 4) {
                                Text("\(Int(weather.temperature))°")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                                Text("C")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                                    .padding(.top, 8)
                            }
                            
                            HStack(spacing: 16) {
                                weatherDetail(icon: "wind", value: "\(Int(weather.windSpeed)) km/h")
                                weatherDetail(icon: "humidity.fill", value: "\(weather.humidity)%")
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: weatherIcon(for: weather.weatherCode))
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primary)
                            .symbolRenderingMode(.hierarchical)
                    }
                } else {
                    emptyStateView(message: "No weather data")
                }
            }
        }
    }
    
    private func weatherDetail(icon: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func weatherIcon(for code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1, 2, 3: return "cloud.sun.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51...67: return "cloud.rain.fill"
        case 71...77: return "cloud.snow.fill"
        case 80...82: return "cloud.heavyrain.fill"
        case 95...99: return "cloud.bolt.rain.fill"
        default: return "sun.max.fill"
        }
    }
    
    // MARK: - Currency Summary Card
    private var currencySummaryCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                cardHeader(title: "Currency Converter", icon: "dollarsign.circle.fill") {
                    selectedTab = .currency
                }
                
                if viewModel.currencyViewModel.isLoading {
                    SkeletonView()
                        .frame(height: 100)
                } else if let error = viewModel.currencyViewModel.errorMessage {
                    errorView(message: error)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        currencyConversionRow(
                            from: viewModel.currencyViewModel.fromCurrency,
                            to: viewModel.currencyViewModel.toCurrency,
                            amount: viewModel.currencyViewModel.amount,
                            result: viewModel.currencyViewModel.convertedAmount
                        )
                        
                        Text("Quick conversions from 1 USD")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                        
                        HStack(spacing: 16) {
                            quickCurrencyBadge(currency: "CNY", rate: viewModel.cnyRate)
                            quickCurrencyBadge(currency: "GBP", rate: viewModel.gbpRate)
                            quickCurrencyBadge(currency: "JPY", rate: viewModel.jpyRate)
                        }
                    }
                }
            }
        }
    }
    
    private func currencyConversionRow(from: Currency, to: Currency, amount: String, result: String?) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(from.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Text(amount.isEmpty ? "0.00" : amount)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Image(systemName: "arrow.right")
                .foregroundColor(AppColors.primary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(to.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Text(result ?? "0.00")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.primary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func quickCurrencyBadge(currency: String, rate: String) -> some View {
        VStack(spacing: 4) {
            Text(currency)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primary)
            Text(rate)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(AppColors.primary.opacity(0.1))
        .cornerRadius(8)
    }
    
    // MARK: - GitHub Summary Card
    private var githubSummaryCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                cardHeader(title: "Trending Repositories", icon: "chevron.left.slash.chevron.right") {
                    selectedTab = .github
                }
                
                if viewModel.githubViewModel.isLoading && viewModel.githubViewModel.repositories.isEmpty {
                    SkeletonView()
                        .frame(height: 180)
                } else if let error = viewModel.githubViewModel.errorMessage {
                    errorView(message: error)
                } else if viewModel.topRepos.isEmpty {
                    emptyStateView(message: "No repositories found")
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.topRepos) { repo in
                            repoRow(repo: repo)
                            if repo.id != viewModel.topRepos.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func repoRow(repo: GitHubRepo) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            if let description = repo.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack(spacing: 12) {
                if let language = repo.language {
                    Label(language, systemImage: "circle.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Label("\(repo.stargazersCount)", systemImage: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Helper Views
    private func cardHeader(title: String, icon: String, action: @escaping () -> Void) -> some View {
        HStack {
            Label {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primary)
            }
            
            Spacer()
            
            Button(action: action) {
                Text("View More")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.primary.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func emptyStateView(message: String) -> some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.secondary)
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
}
