//
//  MockNewsService.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Foundation
@testable import DiscoverHub

/// Mock implementation of NewsServiceProtocol for testing
class MockNewsService: NewsServiceProtocol {
    
    // Test configuration
    var articlesToReturn: [NewsArticle] = []
    var errorToThrow: Error?
    var shouldDelay: Bool = false
    var delayDuration: TimeInterval = 0.1
    
    // Tracking calls
    var fetchTopHeadlinesCalled = false
    var searchNewsCalled = false
    var lastSearchQuery: String?
    
    func fetchTopHeadlines() async throws -> [NewsArticle] {
        fetchTopHeadlinesCalled = true
        
        if shouldDelay {
            try? await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return articlesToReturn
    }
    
    func searchNews(query: String) async throws -> [NewsArticle] {
        searchNewsCalled = true
        lastSearchQuery = query
        
        if shouldDelay {
            try? await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return articlesToReturn
    }
    
    // Helper to reset state between tests
    func reset() {
        articlesToReturn = []
        errorToThrow = nil
        shouldDelay = false
        fetchTopHeadlinesCalled = false
        searchNewsCalled = false
        lastSearchQuery = nil
    }
}
