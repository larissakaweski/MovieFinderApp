//
//  MovieDetailViewModel.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func didLoadMovieDetails(_ movie: Movie, isFavorite: Bool)
    func didUpdateFavoriteStatus(_ isFavorite: Bool)
    func didShowError(_ message: String)
    func didStartLoading()
    func didStopLoading()
}

class MovieDetailViewModel {
    
    // MARK: - Properties
    weak var delegate: MovieDetailViewModelDelegate?
    
    private let movie: Movie
    private let movieService: MovieServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    private var movieDetail: MovieDetail?
    private var isLoading = false
    
    // MARK: - Computed Properties
    var currentMovie: Movie {
        return movieDetail?.asMovie() ?? movie
    }
    
    var isFavorite: Bool {
        return favoritesService.isFavorite(currentMovie)
    }
    
    // MARK: - Initialization
    init(movie: Movie,
         movieService: MovieServiceProtocol = MovieService(),
         favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
        self.movie = movie
        self.movieService = movieService
        self.favoritesService = favoritesService
    }
    
    // MARK: - Public Methods
    func loadMovieDetails() {
        guard !isLoading else { return }
        
        isLoading = true
        delegate?.didStartLoading()
        
        movieService.getMovieDetails(movieId: movie.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.delegate?.didStopLoading()
                
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                    let movie = detail.asMovie()
                    let isFavorite = self?.favoritesService.isFavorite(movie) ?? false
                    self?.delegate?.didLoadMovieDetails(movie, isFavorite: isFavorite)
                    
                case .failure(let error):
                    let errorMessage = self?.getErrorMessage(for: error) ?? "Erro ao carregar detalhes do filme"
                    self?.delegate?.didShowError(errorMessage)
                }
            }
        }
    }
    
    func toggleFavorite() {
        let movie = currentMovie
        
        if favoritesService.isFavorite(movie) {
            favoritesService.removeFromFavorites(movie)
            delegate?.didUpdateFavoriteStatus(false)
        } else {
            favoritesService.addToFavorites(movie)
            delegate?.didUpdateFavoriteStatus(true)
        }
    }
    
    // MARK: - Private Methods
    private func getErrorMessage(for error: NetworkError) -> String {
        error.errorDescription ?? error.localizedDescription
    }
} 
