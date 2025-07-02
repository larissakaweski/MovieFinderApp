//
//  MovieResultsViewController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class MovieResultsViewController: UIViewController {
    
    private let contentView: MovieResultsView
    private let viewModel: MovieResultViewModelProtocol
    
    private let searchQuery: String
    private var movies: [Movie] = []
    private var hasMorePages = false
    
    init(searchQuery: String,
         contentView: MovieResultsView,
         viewModel: MovieResultViewModelProtocol) {
        self.searchQuery = searchQuery
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resultados: \(searchQuery)"
        view.backgroundColor = .systemBackground
        contentView.delegate = self
        contentView.isFavoriteHandler = { [weak self] movie in
            guard let self = self else { return false }
            return self.viewModel.isFavorite(movie)
        }
        contentView.updateMovies([], hasMorePages: true)
        setupViewModel()
        performSearch()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func performSearch() {
        viewModel.resultMovies(query: searchQuery, resetPage: true)
    }
    
    private func loadMoreMovies() {
        viewModel.loadMoreMovies(query: searchQuery)
    }
}

extension MovieResultsViewController: MovieResultsViewDelegate {
    func movieResultsView(_ view: MovieResultsView, didSelectMovieAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let movieService = MovieService()
        let view = MovieDetailView()
        
        let viewModel = MovieDetailViewModel(movie: movie, movieService: movieService, favoritesService: FavoritesService.shared)
        
        let detailVC = MovieDetailViewController(movie: movie, contentView: view, viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func movieResultsViewDidReachEnd(_ view: MovieResultsView) {
        if hasMorePages {
            loadMoreMovies()
        }
    }
    
    func movieResultsView(_ view: MovieResultsView, didTapFavoriteAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        viewModel.toggleFavorite(movie)
        performHapticFeedback()
        movies = viewModel.movies
        contentView.reloadItem(at: indexPath)
    }
}

extension MovieResultsViewController: MovieResultViewModelDelegate {
    func didUpdateMovies() {
        movies = viewModel.movies
        hasMorePages = viewModel.hasMorePages
        contentView.updateMovies(movies, hasMorePages: hasMorePages)
    }
    
    func didStartLoading() {
        contentView.startLoading()
    }
    
    func didFinishLoading() {
        contentView.stopLoading()
    }
    
    func didShowError(_ message: String) {
        contentView.showError(message)
    }
} 
