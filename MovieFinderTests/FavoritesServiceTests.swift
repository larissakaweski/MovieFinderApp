//
//  FavoritesServiceTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class FavoritesServiceTests: XCTestCase {
    
    var favoritesService: FavoritesService!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        favoritesService = FavoritesService(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        favoritesService = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testAddToFavorites() {
        // Given
        let movie = createMockMovie()
        
        // When
        favoritesService.addToFavorites(movie)
        
        // Then
        XCTAssertTrue(favoritesService.isFavorite(movie))
        XCTAssertEqual(favoritesService.getFavorites().count, 1)
        XCTAssertTrue(mockUserDefaults.setCalled)
    }
    
    func testAddToFavoritesDuplicate() {
        // Given
        let movie = createMockMovie()
        favoritesService.addToFavorites(movie)
        
        // When
        favoritesService.addToFavorites(movie) // Add same movie again
        
        // Then
        XCTAssertTrue(favoritesService.isFavorite(movie))
        XCTAssertEqual(favoritesService.getFavorites().count, 1)
    }
    
    func testRemoveFromFavorites() {
        // Given
        let movie = createMockMovie()
        favoritesService.addToFavorites(movie)
        
        // When
        favoritesService.removeFromFavorites(movie)
        
        // Then
        XCTAssertFalse(favoritesService.isFavorite(movie))
        XCTAssertEqual(favoritesService.getFavorites().count, 0)
        XCTAssertTrue(mockUserDefaults.setCalled)
    }
    
    func testRemoveFromFavoritesNotInFavorites() {
        // Given
        let movie = createMockMovie()
        
        // When
        favoritesService.removeFromFavorites(movie)
        
        // Then
        XCTAssertFalse(favoritesService.isFavorite(movie))
        XCTAssertEqual(favoritesService.getFavorites().count, 0)
    }
    
    func testIsFavorite() {
        // Given
        let movie = createMockMovie()
        
        // When & Then
        XCTAssertFalse(favoritesService.isFavorite(movie))
        
        // When
        favoritesService.addToFavorites(movie)
        
        // Then
        XCTAssertTrue(favoritesService.isFavorite(movie))
    }
    
    func testGetFavorites() {
        // Given
        let movie1 = createMockMovie(id: 1, title: "Movie 1")
        let movie2 = createMockMovie(id: 2, title: "Movie 2")
        
        // When
        favoritesService.addToFavorites(movie1)
        favoritesService.addToFavorites(movie2)
        
        // Then
        let favorites = favoritesService.getFavorites()
        XCTAssertEqual(favorites.count, 2)
        XCTAssertTrue(favorites.contains { $0.id == 1 })
        XCTAssertTrue(favorites.contains { $0.id == 2 })
    }
    
    func testClearFavorites() {
        // Given
        let movie1 = createMockMovie(id: 1, title: "Movie 1")
        let movie2 = createMockMovie(id: 2, title: "Movie 2")
        favoritesService.addToFavorites(movie1)
        favoritesService.addToFavorites(movie2)
        
        // When
        favoritesService.clearFavorites()
        
        // Then
        XCTAssertEqual(favoritesService.getFavorites().count, 0)
        XCTAssertFalse(favoritesService.isFavorite(movie1))
        XCTAssertFalse(favoritesService.isFavorite(movie2))
        XCTAssertTrue(mockUserDefaults.removeObjectCalled)
    }
    
    func testMultipleMovies() {
        // Given
        let movies = [
            createMockMovie(id: 1, title: "Movie 1"),
            createMockMovie(id: 2, title: "Movie 2"),
            createMockMovie(id: 3, title: "Movie 3")
        ]
        
        // When
        for movie in movies {
            favoritesService.addToFavorites(movie)
        }
        
        // Then
        XCTAssertEqual(favoritesService.getFavorites().count, 3)
        
        // When - remove one
        favoritesService.removeFromFavorites(movies[1])
        
        // Then
        XCTAssertEqual(favoritesService.getFavorites().count, 2)
        XCTAssertTrue(favoritesService.isFavorite(movies[0]))
        XCTAssertFalse(favoritesService.isFavorite(movies[1]))
        XCTAssertTrue(favoritesService.isFavorite(movies[2]))
    }
    
    func testGetFavoritesWithInvalidData() {
        // Given
        mockUserDefaults.mockData = Data("invalid json".utf8)
        
        // When
        let favorites = favoritesService.getFavorites()
        
        // Then
        XCTAssertEqual(favorites.count, 0)
    }
    
    func testGetFavoritesWithNoData() {
        // Given
        mockUserDefaults.mockData = nil
        
        // When
        let favorites = favoritesService.getFavorites()
        
        // Then
        XCTAssertEqual(favorites.count, 0)
    }
    
    func testSaveFavoritesWithEncodingError() {
        // Given
        let movie = createMockMovie()
        mockUserDefaults.shouldFailSet = true
        
        // When
        favoritesService.addToFavorites(movie)
        
        // Then
        // Should not crash, just log error
        XCTAssertTrue(mockUserDefaults.setCalled)
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
