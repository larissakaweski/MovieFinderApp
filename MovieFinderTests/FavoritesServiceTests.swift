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
    
    override func setUp() {
        super.setUp()
        favoritesService = FavoritesService.shared
        favoritesService.clearFavorites() // Clear any existing favorites
    }
    
    override func tearDown() {
        favoritesService.clearFavorites()
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
    }
    
    func testAddToFavoritesDuplicate() {
        // Given
        let movie = createMockMovie()
        favoritesService.addToFavorites(movie)
        
        // When
        favoritesService.addToFavorites(movie) // Add same movie again
        
        // Then
        XCTAssertTrue(favoritesService.isFavorite(movie))
        XCTAssertEqual(favoritesService.getFavorites().count, 1) // Should still be only 1
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