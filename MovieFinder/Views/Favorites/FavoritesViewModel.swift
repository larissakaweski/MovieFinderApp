//
//  FavoritesViewModel.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateFavorites()
    func didShowError(_ message: String)
}

class FavoritesViewModel {
    weak var delegate: FavoritesViewModelDelegate?
    
    private let favoritesService: FavoritesServiceProtocol
    
    private(set) var favorites: [Movie] = []
    
    init(favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
        self.favoritesService = favoritesService
    }
    
    // MARK: - Load Favorites
    func loadFavorites() {
        favorites = favoritesService.getFavorites()
        delegate?.didUpdateFavorites()
    }
    
    // MARK: - Remove from Favorites
    func removeFromFavorites(_ movie: Movie) {
        favoritesService.removeFromFavorites(movie)
        loadFavorites()
    }
    
    // MARK: - Clear All Favorites
    func clearAllFavorites() {
        favoritesService.clearFavorites()
        favorites = []
        delegate?.didUpdateFavorites()
    }
    
    // MARK: - Check if Empty
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    // MARK: - Get Favorite Count
    var count: Int {
        return favorites.count
    }
} 