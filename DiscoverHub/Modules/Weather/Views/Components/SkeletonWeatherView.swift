//
//  SkeletonWeatherView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-31.
//

import SwiftUI

struct SkeletonWeatherView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // Hero Card Skeleton
            AppCard {
                VStack(spacing: AppSpacing.md) {
                    HStack {
                        SkeletonView()
                            .frame(width: 80, height: 24)
                            .cornerRadius(12)
                        Spacer()
                    }
                    
                    HStack {
                        SkeletonView()
                            .frame(width: 100, height: 60)
                            .cornerRadius(8)
                        Spacer()
                        SkeletonView()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    
                    SkeletonView()
                        .frame(height: 16)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                }
                .padding(.vertical, AppSpacing.sm)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.md)
            
            // Details Grid Skeleton
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                ForEach(0..<4, id: \.self) { _ in
                    AppCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SkeletonView()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                SkeletonView()
                                    .frame(width: 60, height: 12)
                                    .cornerRadius(4)
                                
                                SkeletonView()
                                    .frame(width: 40, height: 16)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            
            Spacer()
        }
    }
}

#Preview {
    SkeletonWeatherView()
}
