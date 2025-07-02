//
//  MovieSearchViewController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    private let contentView: MovieSearchView
    
    init(contentView: MovieSearchView) {
        self.contentView = contentView
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
    
    private func setupNavigationBar() {
        title = "Buscar Filmes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDelegates() {
        contentView.delegate = self
    }
}

// MARK: - MovieSearchViewDelegate
extension MovieSearchViewController: MovieSearchViewDelegate {
    func movieSearchViewDidTapSearch(_ view: MovieSearchView) {
        guard let searchText = view.searchText, !searchText.isEmpty else { return }
        
        let view = MovieResultsView()
        let movieService = MovieService()
        
        let viewModel = MovieResultViewModel(movieService: movieService, favoritesService: FavoritesService.shared)
        let resultsViewController = MovieResultsViewController(searchQuery: searchText, contentView: view, viewModel: viewModel)
        navigationController?.pushViewController(resultsViewController, animated: true)
    }
}

