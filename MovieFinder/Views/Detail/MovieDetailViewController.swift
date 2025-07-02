//
//  MovieDetailViewController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let contentView: MovieDetailView
    
    // MARK: - Properties
    private let viewModel: MovieDetailViewModelProtocol
    
    // MARK: - Initialization
    init(movie: Movie,
         contentView: MovieDetailView,
         viewModel: MovieDetailViewModelProtocol) {
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        loadInitialData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Detalhes"
        view.backgroundColor = .systemBackground
        contentView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func loadInitialData() {
        contentView.configure(with: viewModel.currentMovie, isFavorite: viewModel.isFavorite)
        viewModel.loadMovieDetails()
    }
}

// MARK: - MovieDetailViewDelegate
extension MovieDetailViewController: MovieDetailViewDelegate {
    func movieDetailViewDidTapFavorite(_ view: MovieDetailView) {
        viewModel.toggleFavorite()
        performHapticFeedback()
    }
}

// MARK: - MovieDetailViewModelDelegate
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didLoadMovieDetails(_ movie: Movie, isFavorite: Bool) {
        contentView.configure(with: movie, isFavorite: isFavorite)
    }
    
    func didUpdateFavoriteStatus(_ isFavorite: Bool) {
        contentView.configure(with: viewModel.currentMovie, isFavorite: isFavorite)
    }
    
    func didShowError(_ message: String) {
        showAlert(title: "Erro", message: message)
    }
    
    func didStartLoading() {
        contentView.loadingIndicator.startAnimating()
    }
    
    func didStopLoading() {
        contentView.loadingIndicator.stopAnimating()
    }
}
