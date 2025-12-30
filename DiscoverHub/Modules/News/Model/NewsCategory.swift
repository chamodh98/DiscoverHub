//
//  NewsCategory.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-30.
//

import SwiftUI

enum NewsCategory: String, CaseIterable {
    case general = "General"
    case technology = "Technology"
    case business = "Business"
    case sports = "Sports"
    case entertainment = "Entertainment"
    case health = "Health"
    case science = "Science"
    
    
    /// Returns adaptive color based on current color scheme
    func color(for colorScheme: ColorScheme) -> Color {
        AdaptiveColors.categoryColor(for: self, colorScheme: colorScheme)
    }
    
    /// Legacy color property for backward compatibility (uses light mode colors)
    var color: Color {
        switch self {
        case .general:
            return Color.gray
        case .technology:
            return Color.blue
        case .business:
            return Color.green
        case .sports:
            return Color.orange
        case .entertainment:
            return Color.purple
        case .health:
            return Color.red
        case .science:
            return Color.cyan
        }
    }

    
    var icon: String {
        switch self {
        case .general:
            return "newspaper"
        case .technology:
            return "laptopcomputer"
        case .business:
            return "briefcase"
        case .sports:
            return "sportscourt"
        case .entertainment:
            return "film"
        case .health:
            return "heart"
        case .science:
            return "atom"
        }
    }
    
    // Simple heuristic to determine category from article content
    static func detectCategory(from article: NewsArticle) -> NewsCategory {
        let content = (article.title + " " + (article.description ?? "")).lowercased()
        
        if content.contains("tech") || content.contains("apple") || content.contains("google") || content.contains("ai") || content.contains("software") {
            return .technology
        } else if content.contains("business") || content.contains("market") || content.contains("stock") || content.contains("economy") {
            return .business
        } else if content.contains("sport") || content.contains("game") || content.contains("player") || content.contains("team") {
            return .sports
        } else if content.contains("movie") || content.contains("music") || content.contains("celebrity") || content.contains("entertainment") {
            return .entertainment
        } else if content.contains("health") || content.contains("medical") || content.contains("doctor") || content.contains("disease") {
            return .health
        } else if content.contains("science") || content.contains("research") || content.contains("study") || content.contains("discovery") {
            return .science
        }
        
        return .general
    }
}
