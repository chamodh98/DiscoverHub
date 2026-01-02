//
//  SkeletonGitHubView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2026-01-03.
//

import SwiftUI

struct SkeletonGitHubView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(0..<6, id: \.self) { _ in
                    SkeletonView()
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(AppSpacing.md)
        }
    }
}

#Preview {
    SkeletonGitHubView()
}
