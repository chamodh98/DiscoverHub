//
//  AppTabView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .news:
                    NewsView()
                case .weather:
                    WeatherView()
                case .github:
                    GitHubView()
                case .currency:
                    CurrencyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 0) 
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Prevent tab bar from moving up with keyboard
    }
}

#Preview {
    AppTabView()
}
