//
//  GitHubRepoCard.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import SwiftUI

struct GitHubRepoCard: View {
    let repo: GitHubRepo
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Header: Name and Stars
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(repo.name)
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if let fullName = repo.fullName {
                            Text(fullName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(repo.stargazersCount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow.opacity(0.15))
                    .cornerRadius(8)
                }
                
                // Description
                if let desc = repo.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                // Footer: Language and Link
                HStack {
                    if let language = repo.language {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(languageColor(language))
                                .frame(width: 8, height: 8)
                            Text(language)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let urlString = repo.htmlUrl, let url = URL(string: urlString) {
                        Link(destination: url) {
                            HStack(spacing: 4) {
                                Text("View Repo")
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                }
            }
        }
    }
    
    private func languageColor(_ language: String) -> Color {
        switch language.lowercased() {
        case "swift": return .orange
        case "python": return .blue
        case "javascript": return .yellow
        case "typescript": return .teal
        case "html": return .red
        case "css": return .purple
        case "java": return .brown
        case "kotlin": return .purple
        case "go": return .cyan
        case "ruby": return .red
        case "php": return .indigo
        case "c++": return .pink
        case "c": return .gray
        case "shell": return .green
        default: return .gray
        }
    }
}

#Preview {
    GitHubRepoCard(repo: GitHubRepo(
        id: 2,
        name: "GitHub - Swift",
        fullName: "GitHub - SwiftUI Repo",
        description: "GitHub - SwiftUI Repo Description",
        stargazersCount: 4,
        language: "swift",
        htmlUrl: "https://github.com"
    ))
}
