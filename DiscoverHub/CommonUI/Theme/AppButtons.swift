//
//  AppButtons.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(AppGradients.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(AppColors.secondary.opacity(0.15))
            .foregroundColor(AppColors.secondary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
    
}
