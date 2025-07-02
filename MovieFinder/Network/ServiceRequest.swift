//
//  ServiceRequest.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 29/06/25.
//

import Foundation

enum ServiceRequest {
    
    case searchMovies(query: String, page: Int)
    case getMovieDetails(movieId: Int)
    
    var baseUrl: String {
        switch self {
        case .searchMovies, .getMovieDetails:
            return APIConfig.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .searchMovies:
            return "/search/movie"
        case .getMovieDetails:
            return "/movie"
        }
    }
    
    var method: String {
        switch self {
        case .searchMovies, .getMovieDetails:
            return "GET"
        }
    }
    
    var queryParams: [String: Any]? {
        switch self {
        case let .searchMovies(query, page):
            return [
                "api_key": APIConfig.apiKey,
                "query": query,
                "page": page,
                "language": "pt-BR"
            ]
        case .getMovieDetails(_):
            return [
                "api_key": APIConfig.apiKey,
                "language": "pt-BR"
            ]
        }
    }
    
    var fullPath: String {
        switch self {
        case .searchMovies:
            return path
        case let .getMovieDetails(movieId):
            return "\(path)/\(movieId)"
        }
    }
    
    var endpoint: String {
        return fullPath
    }
}
