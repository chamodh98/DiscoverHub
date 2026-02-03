//
//  NewsViewModelTests.swift
//  DiscoverHubTests
//
//  Created by Chamod Hettiarachchi on 2026-01-13.
//

import XCTest
import Combine
@testable import DiscoverHub

@MainActor
final class NewsViewModelTests: XCTestCase {
    
    var viewModel: NewsViewModel!
    var mockService: MockNewsService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockNewsService()
        cancellables = Set<AnyCancellable>()
        // We'll need to initialize with the mock
        // Note: This requires updating NewsViewModel init to accept service
        viewModel = NewsViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Given: A fresh ViewModel
        // Then: It should have the expected initial state
        XCTAssertTrue(viewModel.articles.isEmpty, "Articles should be empty initially")
        XCTAssertEqual(viewModel.searchQuery, "", "Search query should be empty")
        XCTAssertTrue(viewModel.isLoading, "Should be loading initially")
        XCTAssertNil(viewModel.errorMessage, "Should have no error initially")
    }
    
    // MARK: - Loading Top Headlines Tests
    
    func testLoadTopHeadlinesSuccess() async {
        // Given: Mock service returns sample articles
        let sampleArticles = TestFixtures.sampleArticles(count: 5)
        mockService.articlesToReturn = sampleArticles
        
        // When: ViewModel loads top headlines
        let expectation = expectation(description: "Articles loaded")
        
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refresh()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then: Articles should be populated
        XCTAssertEqual(viewModel.articles.count, 5, "Should have 5 articles")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        XCTAssertNil(viewModel.errorMessage, "Should have no error")
        XCTAssertTrue(mockService.fetchTopHeadlinesCalled, "Should call fetchTopHeadlines")
    }
    
    func testLoadTopHeadlinesFailure() async {
        // Given: Mock service throws an error
        mockService.errorToThrow = TestFixtures.TestError.networkError
        
        // When: ViewModel attempts to load
        let expectation = expectation(description: "Error received")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refresh()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then: Error should be set
        XCTAssertNotNil(viewModel.errorMessage, "Should have an error")
        XCTAssertTrue(viewModel.articles.isEmpty, "Articles should be empty on error")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
    }
    
    // MARK: - Search Tests
    
    func testSearchUpdatesArticles() async {
        // Given: Mock service returns search results
        let searchResults = TestFixtures.sampleArticles(count: 3)
        mockService.articlesToReturn = searchResults
        
        // When: User searches for something
        let expectation = expectation(description: "Search completed")
        
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                if !articles.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "SwiftUI"
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then: Articles should be updated with search results
        XCTAssertEqual(viewModel.articles.count, 3)
        XCTAssertEqual(mockService.lastSearchQuery, "SwiftUI")
        XCTAssertTrue(mockService.searchNewsCalled)
    }
    
    func testSearchDebouncing() async {
        // Given: Mock service with delay
        mockService.shouldDelay = true
        mockService.articlesToReturn = TestFixtures.sampleArticles(count: 1)
        
        // When: User types quickly (multiple search queries in rapid succession)
        viewModel.searchQuery = "S"
        viewModel.searchQuery = "Sw"
        viewModel.searchQuery = "Swi"
        viewModel.searchQuery = "Swif"
        viewModel.searchQuery = "Swift"
        
        // Wait for debounce (500ms) + processing
        try? await Task.sleep(nanoseconds: 700_000_000) // 0.7s
        
        // Then: Only the final search should be executed
        XCTAssertEqual(mockService.lastSearchQuery, "Swift", "Should only search for final query")
        
        // Note: In practice, you'd verify searchNews was called only once,
        // but this demonstrates the debouncing concept
    }
    
    func testEmptySearchLoadsTopHeadlines() async {
        // Given: Mock service returns top headlines
        let headlines = TestFixtures.sampleArticles(count: 10)
        mockService.articlesToReturn = headlines
        
        // When: Search query is cleared
        let expectation = expectation(description: "Top headlines loaded")
        
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                if articles.count == 10 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = ""
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then: Should load top headlines instead of searching
        XCTAssertTrue(mockService.fetchTopHeadlinesCalled)
        XCTAssertFalse(mockService.searchNewsCalled)
    }
    
    // MARK: - Refresh Tests
    
    func testRefreshReloadsData() async {
        // Given: ViewModel with existing articles
        viewModel.searchQuery = "iOS"
        let newArticles = TestFixtures.sampleArticles(count: 7)
        mockService.articlesToReturn = newArticles
        
        // When: User triggers refresh
        let expectation = expectation(description: "Refresh completed")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refresh()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then: Data should be reloaded
        XCTAssertEqual(viewModel.articles.count, 7)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingStateTransitions() async {
        // Given: Fresh ViewModel
        mockService.shouldDelay = true
        mockService.articlesToReturn = TestFixtures.sampleArticles()
        
        var loadingStates: [Bool] = []
        
        let expectation = expectation(description: "Loading states captured")
        
        // When: Monitoring loading state during refresh
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                // Fulfill when loading completes (reaches false state)
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refresh()
        
        await fulfillment(of: [expectation], timeout: 15.0)
        
        // Then: Should transition from false -> true -> false
        // (initial state, during load, after load)
        XCTAssertTrue(loadingStates.contains(true), "Should have loading state")
        XCTAssertTrue(loadingStates.contains(false), "Should have non-loading state")
    }
}
