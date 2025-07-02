//
//  APIConfig.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

struct APIConfig {
    // MARK: - TMDb API Configuration
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"
    
    // MARK: - API Key
    static let apiKey = "122f81efb1ab3e5e0fd7755651b9618a"
    
    // MARK: - Image Sizes
    struct ImageSizes {
        static let poster = "w500"
        static let backdrop = "original"
        static let profile = "w185"
    }
    
    // MARK: - Language
    static let language = "pt-BR"
    
    // MARK: - Validation
    static var isConfigured: Bool {
        return !apiKey.isEmpty
    }
} 
