//
//  DiscoverHubTests.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import Testing
import Foundation
import Combine
@testable import DiscoverHub

@MainActor
struct DiscoverHubTests {

    var viewModel: GitHubViewModel
    var mockService: MockGitHubService

    init() {
        let mock = MockGitHubService()
        self.mockService = mock
        self.viewModel = GitHubViewModel(service: mock)
    }

    @Test("Initial state should be correct")
    func initialState() async throws {
        #expect(viewModel.repositories.isEmpty)
        #expect(viewModel.searchText == "swiftui")
        #expect(viewModel.isLoading == true)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Successful search updates repositories")
    func searchSuccess() async throws {
        // Given
        let repos = TestFixtures.sampleRepos(count: 3)
        mockService.repositoriesToReturn = repos
        
        // When
        viewModel.searchText = "test-query"
        
        // Wait for debounce and async search
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1s to be safe for 0.5s debounce
        
        // Then
        #expect(mockService.searchRepositoriesCalled)
        #expect(mockService.lastSearchQuery == "test-query")
        #expect(viewModel.repositories.count == 3)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Failed search sets error message")
    func searchFailure() async throws {
        // Given
        mockService.errorToThrow = TestFixtures.TestError.networkError
        
        // When
        viewModel.searchText = "fail-query"
        
        // Wait for debounce and async search
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        #expect(mockService.searchRepositoriesCalled)
        #expect(viewModel.repositories.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == TestFixtures.TestError.networkError.localizedDescription)
    }

    @Test("Empty search clears repositories")
    func emptySearch() async throws {
        // Given
        viewModel.repositories = TestFixtures.sampleRepos(count: 2)
        
        // When
        viewModel.searchText = ""
        
        // Wait for debounce
        try await Task.sleep(nanoseconds: 700_000_000)
        
        // Then
        #expect(viewModel.repositories.isEmpty)
        #expect(viewModel.isLoading == false)
    }
}
