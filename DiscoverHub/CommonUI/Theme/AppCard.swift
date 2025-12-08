//
//  AppCard.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-09.
//

import SwiftUI

struct AppCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .appShadow(AppShadows.card)
    }
}
