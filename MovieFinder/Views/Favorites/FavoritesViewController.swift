//
//  FavoritesViewController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let contentView: FavoritesView
    private let viewModel: FavoritesViewModelProtocol
    
    init(contentView: FavoritesView,
         viewModel: FavoritesViewModelProtocol) {
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
        setupNavigationBar()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    private func setupNavigationBar() {
        title = "Meus Favoritos"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDelegates() {
        contentView.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - FavoritesViewDelegate
extension FavoritesViewController: FavoritesViewDelegate {
    func favoritesView(_ view: FavoritesView, didSelectMovie movie: Movie) {
        let movieService = MovieService()
        let view = MovieDetailView()
        
        let viewModel = MovieDetailViewModel(movie: movie, movieService: movieService, favoritesService: FavoritesService.shared)
        let detailViewController = MovieDetailViewController(movie: movie, contentView: view, viewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func favoritesView(_ view: FavoritesView, didTapRemoveFavorite movie: Movie) {
        viewModel.removeFromFavorites(movie)
    }
}

// MARK: - FavoritesViewModelDelegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    func didUpdateFavorites() {
        contentView.updateMovies(viewModel.favorites)
    }
    
    func didShowError(_ message: String) {
        showAlert(title: "Erro", message: message)
    }
} 
