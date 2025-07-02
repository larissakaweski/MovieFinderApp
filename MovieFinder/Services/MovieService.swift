//
//  MovieService.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void)
}

class MovieService: MovieServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - Movie Search
    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let serviceRequest = ServiceRequest.searchMovies(query: query, page: page)
        networkManager.performRequest(serviceRequest, completion: completion)
    }
    
    // MARK: - Movie Details
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        let serviceRequest = ServiceRequest.getMovieDetails(movieId: movieId)
        networkManager.performRequest(serviceRequest, completion: completion)
    }
}
