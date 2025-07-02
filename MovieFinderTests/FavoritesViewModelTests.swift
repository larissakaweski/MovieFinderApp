//
//  FavoritesViewModelTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    var mockDelegate: MockFavoritesViewModelDelegate!
    var mockFavoritesService: MockFavoritesService!
    
    override func setUp() {
        super.setUp()
        mockFavoritesService = MockFavoritesService()
        mockDelegate = MockFavoritesViewModelDelegate()
        
        viewModel = FavoritesViewModel(favoritesService: mockFavoritesService)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        mockFavoritesService = nil
        super.tearDown()
    }
    
    func testLoadFavorites() {
        // Given
        let mockMovies = [createMockMovie(id: 1), createMockMovie(id: 2)]
        mockFavoritesService.favoritesResult = mockMovies
        
        // When
        viewModel.loadFavorites()
        
        // Then
        XCTAssertEqual(viewModel.favorites.count, 2)
        XCTAssertTrue(mockFavoritesService.getFavoritesCalled)
        XCTAssertTrue(mockDelegate.didUpdateFavoritesCalled)
    }
    
    func testLoadFavoritesEmpty() {
        // Given
        mockFavoritesService.favoritesResult = []
        
        // When
        viewModel.loadFavorites()
        
        // Then
        XCTAssertEqual(viewModel.favorites.count, 0)
        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertTrue(mockDelegate.didUpdateFavoritesCalled)
    }
    
    func testRemoveFromFavorites() {
        // Given
        let movie = createMockMovie()
        mockFavoritesService.favoritesResult = [movie]
        
        // When
        viewModel.removeFromFavorites(movie)
        
        // Then
        XCTAssertTrue(mockFavoritesService.removeFromFavoritesCalled)
        XCTAssertEqual(mockFavoritesService.lastRemovedMovie?.id, movie.id)
        XCTAssertTrue(mockFavoritesService.getFavoritesCalled)
        XCTAssertTrue(mockDelegate.didUpdateFavoritesCalled)
    }
    
    func testIsEmpty() {
        // Given
        mockFavoritesService.favoritesResult = []
        viewModel.loadFavorites()
        
        // When & Then
        XCTAssertTrue(viewModel.isEmpty)
        
        // Given
        mockFavoritesService.favoritesResult = [createMockMovie()]
        viewModel.loadFavorites()
        
        // When & Then
        XCTAssertFalse(viewModel.isEmpty)
    }
    
    func testCount() {
        // Given
        let mockMovies = [createMockMovie(id: 1), createMockMovie(id: 2), createMockMovie(id: 3)]
        mockFavoritesService.favoritesResult = mockMovies
        viewModel.loadFavorites()
        
        // When & Then
        XCTAssertEqual(viewModel.count, 3)
    }
    
    func testMultipleOperations() {
        // Given
        let movie1 = createMockMovie(id: 1, title: "Movie 1")
        let movie2 = createMockMovie(id: 2, title: "Movie 2")
        mockFavoritesService.favoritesResult = [movie1, movie2]
        
        // When
        viewModel.loadFavorites()
        
        // Then
        XCTAssertEqual(viewModel.favorites.count, 2)
        XCTAssertFalse(viewModel.isEmpty)
        
        // When - remove one
        viewModel.removeFromFavorites(movie1)
        
        // Then
        XCTAssertTrue(mockFavoritesService.removeFromFavoritesCalled)
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
class MockFavoritesViewModelDelegate: FavoritesViewModelDelegate {
    var didUpdateFavoritesCalled = false
    var didShowErrorCalled = false
    var errorMessage: String?
    
    func didUpdateFavorites() {
        didUpdateFavoritesCalled = true
    }
    
    func didShowError(_ message: String) {
        didShowErrorCalled = true
        errorMessage = message
    }
} 