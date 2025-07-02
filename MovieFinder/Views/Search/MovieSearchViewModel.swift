//
//  MovieSearchViewModel.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol MovieSearchViewModelDelegate: AnyObject {
    func didUpdateMovies()
    func didStartLoading()
    func didFinishLoading()
    func didShowError(_ message: String)
}

class MovieSearchViewModel {
    weak var delegate: MovieSearchViewModelDelegate?
    
    private let movieService: MovieServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var currentPage = 1
    private(set) var hasMorePages = true
    
    init(movieService: MovieServiceProtocol = MovieService(),
         favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
        self.movieService = movieService
        self.favoritesService = favoritesService
    }
    
    // MARK: - Search Movies
    func searchMovies(query: String, resetPage: Bool = true) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            movies = []
            delegate?.didUpdateMovies()
            return
        }
        
        if resetPage {
            currentPage = 1
            movies = []
        }
        
        isLoading = true
        delegate?.didStartLoading()
        
        movieService.searchMovies(query: query, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.delegate?.didFinishLoading()
                
                switch result {
                case .success(let movieResponse):
                    let newMovies = movieResponse.results
                    if resetPage {
                        self?.movies = newMovies
                    } else {
                        self?.movies.append(contentsOf: newMovies)
                    }
                    
                    self?.hasMorePages = newMovies.count > 0
                    self?.delegate?.didUpdateMovies()
                    
                case .failure(let error):
                    self?.delegate?.didShowError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Load More Movies
    func loadMoreMovies(query: String) {
        guard !isLoading && hasMorePages else { return }
        
        currentPage += 1
        searchMovies(query: query, resetPage: false)
    }
    
    // MARK: - Favorites Management
    func toggleFavorite(_ movie: Movie) {
        if favoritesService.isFavorite(movie) {
            favoritesService.removeFromFavorites(movie)
        } else {
            favoritesService.addToFavorites(movie)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoritesService.isFavorite(movie)
    }
    
    // MARK: - Clear Results
    func clearResults() {
        movies = []
        currentPage = 1
        hasMorePages = true
        delegate?.didUpdateMovies()
    }
} 
