//
//  TestFixtures.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Foundation
@testable import DiscoverHub

/// Reusable test data fixtures for unit tests
enum TestFixtures {
    
    // MARK: - News Fixtures
    
    static func sampleArticle(
        title: String = "Sample News Article",
        source: String = "BBC News",
        description: String = "This is a sample article description",
        imageUrl: String? = "https://example.com/image.jpg"
    ) -> NewsArticle {
        NewsArticle(
            source: Source(id: "bbc", name: source),
            author: "John Doe",
            title: title,
            description: description,
            url: "https://example.com/article",
            urlToImage: imageUrl,
            publishedAt: "2026-01-13T00:00:00Z",
            content: "Full content here..."
        )
    }
    
    static func sampleArticles(count: Int = 3) -> [NewsArticle] {
        (0..<count).map { index in
            sampleArticle(
                title: "Article \(index + 1)",
                source: "Source \(index + 1)"
            )
        }
    }
    
    // MARK: - Weather Fixtures
    
    static func sampleWeather(
        temperature: Double = 20.0,
        weatherCode: Int = 0,
        humidity: Int = 65
    ) -> CurrentWeather {
        CurrentWeather(
            temperature: temperature,
            windSpeed: 10.5,
            weatherCode: weatherCode,
            humidity: humidity,
            pressure: 1013.25
        )
    }
    
    static func sampleWeatherResponse() -> WeatherResponse {
        WeatherResponse(current: sampleWeather())
    }
    
    // MARK: - GitHub Fixtures
    
    static func sampleRepo(
        name: String = "awesome-swiftui",
        stars: Int = 1000,
        language: String? = "Swift"
    ) -> GitHubRepo {
        GitHubRepo(
            id: Int.random(in: 1...100000),
            name: name,
            fullName: "user/\(name)",
            description: "An awesome SwiftUI repository",
            stargazersCount: stars,
            language: language,
            htmlUrl: "https://github.com/user/\(name)"
        )
    }
    
    static func sampleRepos(count: Int = 3) -> [GitHubRepo] {
        (0..<count).map { index in
            sampleRepo(
                name: "repo-\(index + 1)",
                stars: (index + 1) * 500
            )
        }
    }
    
    // MARK: - Errors
    
    enum TestError: Error, LocalizedError {
        case networkError
        case decodingError
        case serverError(Int)
        
        var errorDescription: String? {
            switch self {
            case .networkError:
                return "Network connection failed"
            case .decodingError:
                return "Failed to decode response"
            case .serverError(let code):
                return "Server error: \(code)"
            }
        }
    }
}
