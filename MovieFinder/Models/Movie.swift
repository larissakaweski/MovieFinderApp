//
//  Movie.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let budget: Int?
    let revenue: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case budget
        case revenue
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSizes.poster)\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSizes.backdrop)\(backdropPath)")
    }
    
    var formattedBudget: String {
        guard let budget = budget, budget > 0 else { return "N/A" }
        return budget.formatCurrency()
    }
    
    var formattedRevenue: String {
        guard let revenue = revenue, revenue > 0 else { return "N/A" }
        return revenue.formatCurrency()
    }
}

struct MovieResponse: Codable, Equatable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDetail: Codable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let budget: Int?
    let revenue: Int?
    let runtime: Int?
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case budget
        case revenue
        case runtime
        case genres
        case productionCompanies = "production_companies"
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSizes.poster)\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(APIConfig.imageBaseURL)/\(APIConfig.ImageSizes.backdrop)\(backdropPath)")
    }
    
    var formattedBudget: String {
        guard let budget = budget, budget > 0 else { return "N/A" }
        return budget.formatCurrency()
    }
    
    var formattedRevenue: String {
        guard let revenue = revenue, revenue > 0 else { return "N/A" }
        return revenue.formatCurrency()
    }
    
    func asMovie() -> Movie {
        return Movie(
            id: self.id,
            title: self.title,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            budget: self.budget,
            revenue: self.revenue
        )
    }
}

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable, Equatable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
} 
