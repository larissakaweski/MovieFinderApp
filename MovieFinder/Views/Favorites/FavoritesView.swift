//
//  FavoritesView.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func favoritesView(_ view: FavoritesView, didSelectMovie movie: Movie)
    func favoritesView(_ view: FavoritesView, didTapRemoveFavorite movie: Movie)
}

class FavoritesView: UIView {
    weak var delegate: FavoritesViewDelegate?
    
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
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Você ainda não tem filmes favoritos"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var favorites: [Movie] = []
    
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
        addSubview(emptyStateLabel)
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "MovieGridCell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: - Métodos públicos
    func updateMovies(_ movies: [Movie]) {
        self.favorites = movies
        collectionView.reloadData()
        updateEmptyState()
    }
    
    func showError(_ message: String) {
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
    }
    
    // MARK: - Métodos privados
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !favorites.isEmpty
    }
}

extension FavoritesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }
        let movie = favorites[indexPath.row]
        cell.updateView(with: movie, isFavorite: true)
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.favoritesView(self, didTapRemoveFavorite: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favorites[indexPath.row]
        delegate?.favoritesView(self, didSelectMovie: movie)
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
