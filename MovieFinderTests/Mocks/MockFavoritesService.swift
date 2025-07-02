import Foundation
@testable import MovieFinder

class MockFavoritesService: FavoritesServiceProtocol {
    var favorites: [Movie] = []
    var addToFavoritesCalled = false
    var removeFromFavoritesCalled = false
    var isFavoriteCalled = false
    var getFavoritesCalled = false
    var clearFavoritesCalled = false
    
    var lastAddedMovie: Movie?
    var lastRemovedMovie: Movie?
    var lastCheckedMovie: Movie?
    var isFavoriteResult = false
    var favoritesResult: [Movie] = []
    
    func addToFavorites(_ movie: Movie) {
        addToFavoritesCalled = true
        lastAddedMovie = movie
        
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }
    
    func removeFromFavorites(_ movie: Movie) {
        removeFromFavoritesCalled = true
        lastRemovedMovie = movie
        favorites.removeAll { $0.id == movie.id }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        isFavoriteCalled = true
        lastCheckedMovie = movie
        return isFavoriteResult || favorites.contains { $0.id == movie.id }
    }
    
    func getFavorites() -> [Movie] {
        getFavoritesCalled = true
        return favoritesResult.isEmpty ? favorites : favoritesResult
    }
    
    func clearFavorites() {
        clearFavoritesCalled = true
        favorites.removeAll()
    }
    
    // Helper methods for testing
    func setFavorites(_ movies: [Movie]) {
        favorites = movies
    }
    
    func reset() {
        favorites.removeAll()
        addToFavoritesCalled = false
        removeFromFavoritesCalled = false
        isFavoriteCalled = false
        getFavoritesCalled = false
        clearFavoritesCalled = false
        lastAddedMovie = nil
        lastRemovedMovie = nil
        lastCheckedMovie = nil
    }
} 