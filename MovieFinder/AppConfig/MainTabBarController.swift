//
//  MainTabBarController.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupViewControllers() {
        // MARK: - Busca Tab
        
        let view = MovieSearchView()
        
        let searchViewController = MovieSearchViewController(contentView: view)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "Busca",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        // MARK: - Favoritos Tab
        let favoritesViewModel = FavoritesViewModel(favoritesService: FavoritesService.shared)
        let favoriteView = FavoritesView()
        let favoritesViewController = FavoritesViewController(contentView: favoriteView, viewModel: favoritesViewModel)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        // MARK: - Set View Controllers
        viewControllers = [searchNavigationController, favoritesNavigationController]
    }
} 
