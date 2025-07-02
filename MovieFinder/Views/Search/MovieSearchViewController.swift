//
//  MovieSearchViewController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    private let contentView: MovieSearchView
    private let viewModel: MovieSearchViewModel
    
    init(contentView: MovieSearchView = MovieSearchView(), viewModel: MovieSearchViewModel = MovieSearchViewModel()) {
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
    
    private func setupNavigationBar() {
        title = "Buscar Filmes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDelegates() {
        contentView.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - MovieSearchViewDelegate
extension MovieSearchViewController: MovieSearchViewDelegate {
    func movieSearchViewDidTapSearch(_ view: MovieSearchView) {
        guard let searchText = view.searchText, !searchText.isEmpty else { return }
        
        let resultsViewController = MovieResultsViewController(searchQuery: searchText)
        navigationController?.pushViewController(resultsViewController, animated: true)
    }
}

// MARK: - MovieSearchViewModelDelegate
extension MovieSearchViewController: MovieSearchViewModelDelegate {
    func didUpdateMovies() {
        // Não é usado nesta tela
    }
    
    func didStartLoading() {
        // Não é usado nesta tela
    }
    
    func didFinishLoading() {
        // Não é usado nesta tela
    }
    
    func didShowError(_ message: String) {
        // Não é usado nesta tela
    }
} 
