//
//  AppTypography.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

enum AppTypography {
    
    struct Title: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    struct Subtitle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    struct Body: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 16))
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(AppTypography.Title())
    }
    
    func subtitleStyle() -> some View {
        self.modifier(AppTypography.Subtitle())
    }
    
    func bodyStyle() -> some View {
        self.modifier(AppTypography.Body())
    }
}
