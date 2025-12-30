//
//  AdaptiveColors.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-30.
//

import SwiftUI

/// Provides adaptive colors that automatically adjust for light and dark mode
enum AdaptiveColors {
    
    // MARK: - Category Colors
    
    /// Returns an adaptive color for news categories that works well in both light and dark modes
    static func categoryColor(for category: NewsCategory, colorScheme: ColorScheme) -> Color {
        switch category {
        case .general:
            return colorScheme == .dark ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.5, green: 0.5, blue: 0.5)
            
        case .technology:
            // Vibrant blue in dark mode, deeper blue in light mode
            return colorScheme == .dark ? Color(red: 0.2, green: 0.5, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            
        case .business:
            // Bright green in dark mode, forest green in light mode
            return colorScheme == .dark ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color(red: 0.13, green: 0.7, blue: 0.29)
            
        case .sports:
            // Vibrant orange in dark mode, darker orange in light mode
            return colorScheme == .dark ? Color(red: 1.0, green: 0.6, blue: 0.0) : Color(red: 1.0, green: 0.58, blue: 0.0)
            
        case .entertainment:
            // Bright purple in dark mode, deeper purple in light mode
            return colorScheme == .dark ? Color(red: 0.75, green: 0.35, blue: 1.0) : Color(red: 0.69, green: 0.32, blue: 0.87)
            
        case .health:
            // Bright red in dark mode, deeper red in light mode
            return colorScheme == .dark ? Color(red: 1.0, green: 0.27, blue: 0.27) : Color(red: 0.93, green: 0.26, blue: 0.21)
            
        case .science:
            // Bright cyan in dark mode, teal in light mode
            return colorScheme == .dark ? Color(red: 0.2, green: 0.78, blue: 0.93) : Color(red: 0.0, green: 0.67, blue: 0.8)
        }
    }
    
    // MARK: - Overlay Colors
    
    /// Adaptive gradient overlay for images
    static func imageOverlayGradient(colorScheme: ColorScheme) -> LinearGradient {
        let overlayColor = colorScheme == .dark 
            ? Color.black.opacity(0.75)
            : Color.black.opacity(0.6)
        
        return LinearGradient(
            gradient: Gradient(colors: [.clear, overlayColor]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Placeholder Colors
    
    /// Adaptive placeholder color for missing images
    static func placeholderBackground(colorScheme: ColorScheme) -> Color {
        colorScheme == .dark 
            ? Color(white: 0.2) // Darker gray in dark mode
            : Color(white: 0.9) // Light gray in light mode
    }
    
    /// Adaptive placeholder icon color
    static func placeholderIcon(colorScheme: ColorScheme) -> Color {
        colorScheme == .dark
            ? Color(white: 0.4) // Medium gray in dark mode
            : Color(white: 0.7) // Lighter gray in light mode
    }
    
    // MARK: - Card Enhancement
    
    /// Subtle border color for cards to enhance separation in dark mode
    static func cardBorder(colorScheme: ColorScheme) -> Color {
        colorScheme == .dark
            ? Color.white.opacity(0.08) // Subtle white border in dark mode
            : Color.black.opacity(0.05) // Subtle black border in light mode
    }
}

// MARK: - Environment Extension

extension View {
    /// Helper to get current color scheme
    func adaptiveColor<T>(_ transform: @escaping (ColorScheme) -> T) -> some View {
        self.modifier(AdaptiveColorModifier(transform: transform))
    }
}

private struct AdaptiveColorModifier<T>: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let transform: (ColorScheme) -> T
    
    func body(content: Content) -> some View {
        content
    }
}
