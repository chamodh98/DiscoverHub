//
//  RootView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-28.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
            } else {
                AppTabView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show splash for 2.5 seconds then transition to main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
}
