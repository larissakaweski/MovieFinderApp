//
//  FavoritesService.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol FavoritesServiceProtocol {
    func addToFavorites(_ movie: Movie)
    func removeFromFavorites(_ movie: Movie)
    func isFavorite(_ movie: Movie) -> Bool
    func getFavorites() -> [Movie]
    func clearFavorites()
}

protocol UserDefaultsProtocol {
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

class FavoritesService: FavoritesServiceProtocol {
    static let shared = FavoritesService(userDefaults: UserDefaults.standard)
    
    private let userDefaults: UserDefaultsProtocol
    private let favoritesKey = "favorite_movies"
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Save Movie to Favorites
    func addToFavorites(_ movie: Movie) {
        var favorites = getFavorites()
        
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            saveFavorites(favorites)
        }
    }
    
    // MARK: - Remove Movie from Favorites
    func removeFromFavorites(_ movie: Movie) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == movie.id }
        saveFavorites(favorites)
    }
    
    // MARK: - Check if Movie is Favorite
    func isFavorite(_ movie: Movie) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.id == movie.id }
    }
    
    // MARK: - Get All Favorites
    func getFavorites() -> [Movie] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return movies
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    // MARK: - Clear All Favorites
    func clearFavorites() {
        userDefaults.removeObject(forKey: favoritesKey)
    }
    
    // MARK: - Private Methods
    private func saveFavorites(_ movies: [Movie]) {
        do {
            let data = try JSONEncoder().encode(movies)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
