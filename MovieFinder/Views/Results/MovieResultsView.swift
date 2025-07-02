//
//  MovieResultsView.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

protocol MovieResultsViewDelegate: AnyObject {
    func movieResultsView(_ view: MovieResultsView, didSelectMovieAt indexPath: IndexPath)
    func movieResultsViewDidReachEnd(_ view: MovieResultsView)
    func movieResultsView(_ view: MovieResultsView, didTapFavoriteAt indexPath: IndexPath)
}

class MovieResultsView: UIView {
    weak var delegate: MovieResultsViewDelegate?
    var isFavoriteHandler: ((Movie) -> Bool)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum filme encontrado"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var movies: [Movie] = []
    private var isLoading = false
    private var hasMorePages = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(collectionView)
        addSubview(loadingIndicator)
        addSubview(emptyStateLabel)
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "MovieGridCell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: - Métodos públicos
    func updateMovies(_ movies: [Movie], hasMorePages: Bool) {
        self.movies = movies
        self.hasMorePages = hasMorePages
        collectionView.reloadData()
        updateEmptyState()
    }
    
    func reloadItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func startLoading() {
        isLoading = true
        loadingIndicator.startAnimating()
        emptyStateLabel.isHidden = true
    }
    
    func stopLoading() {
        isLoading = false
        loadingIndicator.stopAnimating()
        updateEmptyState()
    }
    
    func showError(_ message: String) {
        stopLoading()
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
    }
    
    // MARK: - Métodos privados
    private func updateEmptyState() {
        let isEmpty = movies.isEmpty && !isLoading
        emptyStateLabel.isHidden = !isEmpty
    }
}

extension MovieResultsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        let isFavorite = isFavoriteHandler?(movie) ?? false
        cell.updateView(with: movie, isFavorite: isFavorite)
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.movieResultsView(self, didTapFavoriteAt: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieResultsView(self, didSelectMovieAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && hasMorePages && !isLoading {
            delegate?.movieResultsViewDidReachEnd(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width - (padding * 2) - spacing
        
        guard availableWidth > 0 else {
            return CGSize(width: 150, height: 300)
        }
        
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: itemWidth * 2.0)
    }
} 
