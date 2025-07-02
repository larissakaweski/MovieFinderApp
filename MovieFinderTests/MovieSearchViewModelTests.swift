//
//  MovieSearchViewModelTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class MovieSearchViewModelTests: XCTestCase {
    
    var viewModel: MovieSearchViewModel!
    var mockDelegate: MockMovieSearchViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        viewModel = MovieSearchViewModel()
        mockDelegate = MockMovieSearchViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testSearchMoviesWithEmptyQuery() {
        // Given
        let emptyQuery = ""
        
        // When
        viewModel.searchMovies(query: emptyQuery)
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateMoviesCalled)
    }
    
    func testSearchMoviesWithWhitespaceQuery() {
        // Given
        let whitespaceQuery = "   "
        
        // When
        viewModel.searchMovies(query: whitespaceQuery)
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateMoviesCalled)
    }
    
    func testClearResults() {
        // Given
        viewModel.movies = [createMockMovie()]
        
        // When
        viewModel.clearResults()
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func testToggleFavorite() {
        // Given
        let movie = createMockMovie()
        
        // When
        viewModel.toggleFavorite(movie)
        
        // Then
        XCTAssertTrue(viewModel.isFavorite(movie))
        
        // When - toggle again
        viewModel.toggleFavorite(movie)
        
        // Then
        XCTAssertFalse(viewModel.isFavorite(movie))
    }
    
    func testLoadMoreMovies() {
        // Given
        viewModel.movies = [createMockMovie()]
        viewModel.isLoading = false
        viewModel.hasMorePages = true
        
        // When
        viewModel.loadMoreMovies(query: "test")
        
        // Then
        XCTAssertEqual(viewModel.currentPage, 2)
    }
    
    func testLoadMoreMoviesWhenLoading() {
        // Given
        viewModel.isLoading = true
        let initialPage = viewModel.currentPage
        
        // When
        viewModel.loadMoreMovies(query: "test")
        
        // Then
        XCTAssertEqual(viewModel.currentPage, initialPage)
    }
    
    func testLoadMoreMoviesWhenNoMorePages() {
        // Given
        viewModel.hasMorePages = false
        let initialPage = viewModel.currentPage
        
        // When
        viewModel.loadMoreMovies(query: "test")
        
        // Then
        XCTAssertEqual(viewModel.currentPage, initialPage)
    }
    
    // MARK: - Helper Methods
    private func createMockMovie() -> Movie {
        return Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: "/test.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: 1000000,
            revenue: 5000000
        )
    }
}

// MARK: - Mock Delegate
class MockMovieSearchViewModelDelegate: MovieSearchViewModelDelegate {
    var didUpdateMoviesCalled = false
    var didStartLoadingCalled = false
    var didFinishLoadingCalled = false
    var didShowErrorCalled = false
    var errorMessage: String?
    
    func didUpdateMovies() {
        didUpdateMoviesCalled = true
    }
    
    func didStartLoading() {
        didStartLoadingCalled = true
    }
    
    func didFinishLoading() {
        didFinishLoadingCalled = true
    }
    
    func didShowError(_ message: String) {
        didShowErrorCalled = true
        errorMessage = message
    }
} 