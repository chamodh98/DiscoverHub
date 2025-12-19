//
//  GitHubRepoCard.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-20.
//

import SwiftUI

struct GitHubRepoCard: View {
    let repo: GitHubRepo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repo.name)
            
            if let desc = repo.description {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(repo.stargazersCount)", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                
                if let language = repo.language {
                    Text(language)
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )

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
        htmlURL: "https://github.com"
    ))
}
