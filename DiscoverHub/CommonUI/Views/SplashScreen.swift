//
//  SplashScreen.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-28.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.primary.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .hueRotation(.degrees(rotationAngle))
            
            VStack(spacing: 24) {
                // App Icon/Logo
                ZStack {
                    // Pulsing background circle
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .opacity(isAnimating ? 0.5 : 1.0)
                    
                    // Main icon container
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                    
                    // Icon symbols
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "newspaper.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.primary)
                                .rotationEffect(.degrees(isAnimating ? 0 : -20))
                            
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.secondary)
                                .rotationEffect(.degrees(isAnimating ? 0 : 20))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left.slash.chevron.right")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.primary)
                                .rotationEffect(.degrees(isAnimating ? 0 : 20))
                            
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.secondary)
                                .rotationEffect(.degrees(isAnimating ? 0 : -20))
                        }
                    }
                }
                
                // App Name
                VStack(spacing: 8) {
                    Text("DiscoverHub")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                    
                    Text("Your Daily Digest")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimating = true
            }
            
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                rotationAngle = 30
            }
        }
    }
}

#Preview {
    SplashScreen()
}
