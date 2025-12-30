//
//  SkeletonView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-30.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.15),
                        Color.gray.opacity(0.3)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .white, location: 0.5),
                                .init(color: .clear, location: 1)
                            ]),
                            startPoint: isAnimating ? .leading : .trailing,
                            endPoint: isAnimating ? .trailing : .leading
                        )
                    )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating.toggle()
                }
            }
    }
}

// Skeleton News Card
struct SkeletonNewsCard: View {
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Category badge skeleton
                SkeletonView()
                    .frame(width: 80, height: 20)
                    .cornerRadius(6)
                
                HStack(alignment: .top, spacing: AppSpacing.md) {
                    // Image skeleton
                    SkeletonView()
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Title skeleton
                        SkeletonView()
                            .frame(height: 16)
                            .cornerRadius(4)
                        
                        SkeletonView()
                            .frame(height: 16)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(4)
                        
                        // Description skeleton
                        SkeletonView()
                            .frame(height: 14)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(4)
                        
                        SkeletonView()
                            .frame(width: 120, height: 14)
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        // Source skeleton
                        HStack {
                            SkeletonView()
                                .frame(width: 80, height: 12)
                                .cornerRadius(4)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        SkeletonNewsCard()
        SkeletonNewsCard()
    }
    .padding()
}
