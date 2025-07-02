//
//  MovieResultViewModelTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class MovieResultViewModelTests: XCTestCase {
    
    var viewModel: MovieResultViewModel!
    var mockDelegate: MockMovieResultViewModelDelegate!
    var mockMovieService: MockMovieService!
    var mockFavoritesService: MockFavoritesService!
    
    override func setUp() {
        super.setUp()
        mockMovieService = MockMovieService()
        mockFavoritesService = MockFavoritesService()
        mockDelegate = MockMovieResultViewModelDelegate()
        
        viewModel = MovieResultViewModel(
            movieService: mockMovieService,
            favoritesService: mockFavoritesService
        )
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        mockMovieService = nil
        mockFavoritesService = nil
        super.tearDown()
    }
    
    func testResultMoviesWithEmptyQuery() {
        // Given
        let emptyQuery = ""
        
        // When
        viewModel.resultMovies(query: emptyQuery)
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateMoviesCalled)
        XCTAssertFalse(mockMovieService.searchMoviesCalled)
    }
    
    func testResultMoviesWithWhitespaceQuery() {
        // Given
        let whitespaceQuery = "   "
        
        // When
        viewModel.resultMovies(query: whitespaceQuery)
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateMoviesCalled)
        XCTAssertFalse(mockMovieService.searchMoviesCalled)
    }
    
    func testResultMoviesWithValidQuery() {
        // Given
        let query = "test"
        let mockMovies = [createMockMovie()]
        let mockResponse = MovieResponse(page: 1, results: mockMovies, totalPages: 10, totalResults: 100)
        mockMovieService.mockSearchResult = .success(mockResponse)
        
        // When
        viewModel.resultMovies(query: query)
        
        // Then
        XCTAssertTrue(mockMovieService.searchMoviesCalled)
        XCTAssertEqual(mockMovieService.lastQuery, query)
        XCTAssertEqual(mockMovieService.lastPage, 1)
    }
    
    func testResultMoviesSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Search movies success")
        let query = "test"
        let mockMovies = [createMockMovie()]
        let mockResponse = MovieResponse(page: 1, results: mockMovies, totalPages: 10, totalResults: 100)
        mockMovieService.mockSearchResult = .success(mockResponse)
        
        // When
        viewModel.resultMovies(query: query)
        
        // Simulate async completion
        DispatchQueue.main.async {
            self.mockMovieService.completeSearch()
            
            // Then
            DispatchQueue.main.async {
                XCTAssertEqual(self.viewModel.movies.count, 1)
                XCTAssertTrue(self.viewModel.hasMorePages)
                XCTAssertTrue(self.mockDelegate.didUpdateMoviesCalled)
                XCTAssertTrue(self.mockDelegate.didStartLoadingCalled)
                XCTAssertTrue(self.mockDelegate.didFinishLoadingCalled)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testResultMoviesFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Search movies failure")
        let query = "test"
        let error = NetworkError.invalidResponse
        mockMovieService.mockSearchResult = .failure(error)
        
        // When
        viewModel.resultMovies(query: query)
        
        // Simulate async completion
        DispatchQueue.main.async {
            self.mockMovieService.completeSearch()
            
            // Then
            DispatchQueue.main.async {
                XCTAssertTrue(self.viewModel.movies.isEmpty)
                XCTAssertTrue(self.mockDelegate.didShowErrorCalled)
                XCTAssertEqual(self.mockDelegate.errorMessage, error.localizedDescription)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
   
    func testLoadMoreMoviesWhenNoMorePages() {
        // Given
        let query = "test"
        
        // When
        viewModel.loadMoreMovies(query: query)
        
        // Then
        XCTAssertFalse(mockMovieService.searchMoviesCalled)
    }
    
    func testToggleFavorite() {
        // Given
        let movie = createMockMovie()
        
        // When
        viewModel.toggleFavorite(movie)
        
        // Then
        XCTAssertTrue(mockFavoritesService.addToFavoritesCalled)
        XCTAssertEqual(mockFavoritesService.lastAddedMovie?.id, movie.id)
        
        // When - toggle again (should remove)
        mockFavoritesService.isFavoriteResult = true
        viewModel.toggleFavorite(movie)
        
        // Then
        XCTAssertTrue(mockFavoritesService.removeFromFavoritesCalled)
        XCTAssertEqual(mockFavoritesService.lastRemovedMovie?.id, movie.id)
    }
    
    func testIsFavorite() {
        // Given
        let movie = createMockMovie()
        mockFavoritesService.isFavoriteResult = true
        
        // When
        let result = viewModel.isFavorite(movie)
        
        // Then
        XCTAssertTrue(result)
        XCTAssertTrue(mockFavoritesService.isFavoriteCalled)
        XCTAssertEqual(mockFavoritesService.lastCheckedMovie?.id, movie.id)
    }
    
    func testClearResults() {
        // Given
        // Add a movie through the service to set up the state
        let mockMovies = [createMockMovie()]
        let mockResponse = MovieResponse(page: 1, results: mockMovies, totalPages: 10, totalResults: 100)
        mockMovieService.mockSearchResult = .success(mockResponse)
        viewModel.resultMovies(query: "test")
        mockMovieService.completeSearch()
        
        // When
        viewModel.clearResults()
        
        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateMoviesCalled)
    }
    
    // MARK: - Helper Methods
    private func createMockMovie(id: Int = 1, title: String = "Test Movie") -> Movie {
        return Movie(
            id: id,
            title: title,
            originalTitle: "\(title) Original",
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
class MockMovieResultViewModelDelegate: MovieResultViewModelDelegate {
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

 
