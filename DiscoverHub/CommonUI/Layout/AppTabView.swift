//
//  AppTabView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct AppTabView: View {
    init() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(AppColors.primary).cgColor,
            UIColor(AppColors.secondary).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        //Prepare a UIImage form gradient
        let screenWidth = UIScreen.main.bounds.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 70)
        
        let renderer = UIGraphicsImageRenderer(size: gradientLayer.frame.size)
        let gradientImage = renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
        
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = gradientImage
        appearance.backgroundColor = .clear
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .white.withAlphaComponent(0.65)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.65)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("NEWS")
                }
            
            WeatherView()
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Weather")
                }
            
            GitHubView()
                .tabItem {
                    Image(systemName: "chevron.left.slash.chevron.right")
                    Text("GitHub")
                }
            
            CurrencyView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Currency")
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    AppTabView()
}
