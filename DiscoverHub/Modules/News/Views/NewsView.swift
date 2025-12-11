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
            VStack {
                // Search bar
                TextField("Search news...", text: $vm.searchQuery)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.top, AppSpacing.sm)
                
                if vm.isLoading {
                    ProgressView()
                        .padding()
                } else if let err = vm.errorMessage {
                    Text("Error: \(err)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(vm.articles) { article in
                        NavigationLink(destination: NewsDetailView(article: article)) {
                            NewsRow(article: article)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 4)
                        .padding(.trailing, 4)
                    }
                    .listStyle(PlainListStyle())
                    .scrollDismissesKeyboard(.immediately)
                }
            }
            .navigationTitle("News")
            .task {
                await vm.loadTopHeadlines()
            }
        }
        
    }
}

//Row
struct NewsRow: View {
    let article: NewsArticle
    
    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                if let imageURL = article.urlToImage {
                    AsyncImage(url: URL(string: imageURL)) { img in
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(article.title)
                        .subtitleStyle()
                    if let desc = article.description {
                        Text(desc)
                            .bodyStyle()
                            .lineLimit(2)
                    }
                    Text(article.source.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// Detail View
struct NewsDetailView: View {
    let article: NewsArticle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                if let url = article.urlToImage {
                    AsyncImage(url: URL(string: url)) { img in
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                }
                
                Text(article.title)
                    .titleStyle()
                
                HStack {
                    Text(article.source.name)
                    Spacer()
                    Text(article.publishedAt.prefix(10)) // crude date
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                if let content = article.content {
                    Text(content)
                        .bodyStyle()
                } else if let desc = article.description {
                    Text(desc)
                        .bodyStyle()
                }
                
                Link("Read Full Article", destination: URL(string: article.url)!)
                    .padding(.top, AppSpacing.lg)
            }
            .padding()
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewsView()
}
