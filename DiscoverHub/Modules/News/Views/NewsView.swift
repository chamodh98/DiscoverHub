//
//  NewsView.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-08.
//

import SwiftUI

struct NewsView: View {
    @StateObject var vm = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                EnhancedSearchBar(searchQuery: $vm.searchQuery)
                    .padding(.horizontal, 16)
                    .padding(.top, AppSpacing.sm)
                    .padding(.bottom, AppSpacing.xs)
                
                if vm.isLoading {
                    // Skeleton loading
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { _ in
                                SkeletonNewsCard()
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.top, AppSpacing.sm)
                    }
                } else if let err = vm.errorMessage {
                    ErrorStateView(
                        errorMessage: err,
                        retryAction: {
                            vm.refresh()
                        }
                    )
                } else if vm.articles.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Articles Found",
                        message: vm.searchQuery.isEmpty ? "No news articles available at the moment." : "Try adjusting your search terms.",
                        actionTitle: vm.searchQuery.isEmpty ? nil : "Clear Search",
                        action: vm.searchQuery.isEmpty ? nil : { vm.searchQuery = "" }
                    )
                } else {
                    List {
                        ForEach(Array(vm.articles.enumerated()), id: \.element.id) { index, article in
                            ZStack {
                                NavigationLink(destination: NewsDetailView(article: article)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                if index == 0 {
                                    // Hero card for first article
                                    HeroNewsCard(article: article)
                                        .padding(.horizontal, AppSpacing.md)
                                } else {
                                    NewsRow(article: article)
                                        .padding(.horizontal, AppSpacing.md)
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollDismissesKeyboard(.immediately)
                    .refreshable {
                        vm.refresh()
                    }
                }
            }
            .navigationTitle("News")
            .onAppear {
                if vm.articles.isEmpty && vm.searchQuery.isEmpty {
                     // Initial load handled by VM init pipeline, but if returning from detail, no action needed?
                     // Actually, VM init runs once. If View is popped and kept, it's fine.
                     // But if we want to ensure search is cleared:
                     vm.searchQuery = ""
                }
            }
        }
    }
}

// Enhanced Search Bar
struct EnhancedSearchBar: View {
    @Binding var searchQuery: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? AppColors.primary : .secondary)
                .font(.system(size: 16))
            
            TextField("Search news...", text: $searchQuery)
                .focused($isFocused)
            
            if !searchQuery.isEmpty {
                Button(action: {
                    searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? AppColors.primary : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: searchQuery.isEmpty)
    }
}

// Hero Card for top story
struct HeroNewsCard: View {
    let article: NewsArticle
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero Image
            ZStack(alignment: .bottomLeading) {
                if let imageURL = article.urlToImage {
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(AdaptiveColors.placeholderIcon(colorScheme: colorScheme))
                                )
                        case .empty:
                            AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                .overlay(ProgressView())
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 220)
                    .clipped()
                } else {
                    AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                        .frame(height: 220)
                        .overlay(
                            Image(systemName: "newspaper")
                                .font(.largeTitle)
                                .foregroundColor(AdaptiveColors.placeholderIcon(colorScheme: colorScheme))
                        )
                }
                
                // Gradient overlay
                AdaptiveColors.imageOverlayGradient(colorScheme: colorScheme)
                    .frame(height: 220)
                
                // Category badge on image
                HStack {
                    CategoryBadge(category: NewsCategory.detectCategory(from: article))
                    Spacer()
                }
                .padding(12)
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(article.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(3)
                
                if let desc = article.description {
                    Text(desc)
                        .bodyStyle()
                        .lineLimit(2)
                }
                
                HStack {
                    Text(article.source.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(article.publishedAt.toRelativeTime())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "bookmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
        }
        .cornerRadius(16)
        .appShadow(AppShadows.card)
        .shadow(radius: 5)
    }
}

// Enhanced News Row
struct NewsRow: View {
    let article: NewsArticle
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Category and time
                HStack {
                    CategoryBadge(category: NewsCategory.detectCategory(from: article))
                    
                    Spacer()
                    
                    Text(article.publishedAt.toRelativeTime())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(alignment: .top, spacing: AppSpacing.md) {
                    if let imageURL = article.urlToImage {
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(AdaptiveColors.placeholderIcon(colorScheme: colorScheme))
                                    )
                            case .empty:
                                AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                    .overlay(ProgressView())
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(article.title)
                            .subtitleStyle()
                            .lineLimit(3)
                        
                        if let desc = article.description {
                            Text(desc)
                                .bodyStyle()
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(article.source.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Image(systemName: "bookmark")
                                .font(.caption)
                                .foregroundColor(.secondary)
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

// Category Badge Component
struct CategoryBadge: View {
    let category: NewsCategory
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption2)
            Text(category.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(category.color(for: colorScheme))
        .cornerRadius(6)
    }
}

// Enhanced Detail View
struct NewsDetailView: View {
    let article: NewsArticle
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Parallax Header Image
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    
                    if let url = article.urlToImage {
                        AsyncImage(url: URL(string: url)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.height + (offset > 0 ? offset : 0)
                                    )
                                    .offset(y: offset > 0 ? -offset : 0)
                            case .failure(_):
                                AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(AdaptiveColors.placeholderIcon(colorScheme: colorScheme))
                                    )
                            case .empty:
                                AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                                    .overlay(ProgressView())
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .clipped()
                    } else {
                        AdaptiveColors.placeholderBackground(colorScheme: colorScheme)
                            .overlay(
                                Image(systemName: "newspaper")
                                    .font(.largeTitle)
                                    .foregroundColor(AdaptiveColors.placeholderIcon(colorScheme: colorScheme))
                            )
                    }
                }
                .frame(height: 300)
                
                // Content
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    // Category Badge
                    CategoryBadge(category: NewsCategory.detectCategory(from: article))
                    
                    Text(article.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "building.2")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(article.source.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(article.publishedAt.toFormattedDate())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding(.vertical, AppSpacing.sm)
                    
                    if let author = article.author {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.secondary)
                            Text("By \(author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, AppSpacing.sm)
                    }
                    
                    if let content = article.content {
                        Text(content)
                            .font(.system(size: 17))
                            .foregroundColor(AppColors.textPrimary)
                            .lineSpacing(6)
                    } else if let desc = article.description {
                        Text(desc)
                            .font(.system(size: 17))
                            .foregroundColor(AppColors.textPrimary)
                            .lineSpacing(6)
                    }
                    
                    // Read Full Article Button
                    Link(destination: URL(string: article.url)!) {
                        HStack {
                            Text("Read Full Article")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.up.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppColors.primary)
                        .cornerRadius(12)
                    }
                    .padding(.top, AppSpacing.lg)
                }
                .padding(AppSpacing.md)
            }
        }
        .padding(.top, 10)
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: article.url)!) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
