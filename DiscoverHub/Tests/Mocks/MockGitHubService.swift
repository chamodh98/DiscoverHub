//
//  MockGitHubService.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Foundation
@testable import DiscoverHub

/// Mock implementation of GitHubServiceProtocol for testing
class MockGitHubService: GitHubServiceProtocol {
    
    // Test configuration
    var repositoriesToReturn: [GitHubRepo] = []
    var errorToThrow: Error?
    var shouldDelay: Bool = false
    var delayDuration: TimeInterval = 0.1
    
    // Tracking calls
    var searchRepositoriesCalled = false
    var lastSearchQuery: String?
    
    func searchRepositories(query: String) async throws -> [GitHubRepo] {
        searchRepositoriesCalled = true
        lastSearchQuery = query
        
        if shouldDelay {
            try? await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return repositoriesToReturn
    }
    
    func reset() {
        repositoriesToReturn = []
        errorToThrow = nil
        shouldDelay = false
        searchRepositoriesCalled = false
        lastSearchQuery = nil
    }
}
