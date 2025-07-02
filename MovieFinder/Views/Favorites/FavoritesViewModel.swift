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

protocol FavoritesViewModelProtocol: AnyObject {
    var delegate: FavoritesViewModelDelegate? { get set }
    var favorites: [Movie] { get }
    
    func loadFavorites()
    func removeFromFavorites(_ movie: Movie)
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    weak var delegate: FavoritesViewModelDelegate?
    
    private let favoritesService: FavoritesServiceProtocol
    
    private(set) var favorites: [Movie] = []
    
    init(favoritesService: FavoritesServiceProtocol) {
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
    
    // MARK: - Check if Empty
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    // MARK: - Get Favorite Count
    var count: Int {
        return favorites.count
    }
} 
