//
//  MovieServiceTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class MovieServiceTests: XCTestCase {
    
    var movieService: MovieService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        movieService = MovieService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        movieService = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testSearchMovies() {
        // Given
        let query = "test"
        let page = 1
        let mockResponse = MovieResponse(page: 1, results: [createMockMovie()], totalPages: 10, totalResults: 100)
        mockNetworkManager.mockSearchResult = .success(mockResponse)
        
        // When
        movieService.searchMovies(query: query, page: page) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.page, 1)
                XCTAssertEqual(response.results.count, 1)
                XCTAssertEqual(response.totalPages, 10)
                XCTAssertEqual(response.totalResults, 100)
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        // Verify network manager was called correctly
        XCTAssertTrue(mockNetworkManager.performRequestCalled)
    }
    
    func testSearchMoviesFailure() {
        // Given
        let query = "test"
        let error = NetworkError.invalidResponse
        mockNetworkManager.mockSearchResult = .failure(error)
        
        // When
        movieService.searchMovies(query: query, page: 1) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let networkError):
                XCTAssertEqual(networkError, error)
            }
        }
    }
    
    func testGetMovieDetails() {
        // Given
        let movieId = 123
        let mockDetail = createMockMovieDetail()
        mockNetworkManager.mockDetailResult = .success(mockDetail)
        
        // When
        movieService.getMovieDetails(movieId: movieId) { result in
            // Then
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.id, movieId)
                XCTAssertEqual(detail.title, "Test Movie Detail")
                XCTAssertEqual(detail.runtime, 120)
                XCTAssertEqual(detail.genres.count, 2)
                XCTAssertEqual(detail.productionCompanies.count, 1)
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        // Verify network manager was called correctly
        XCTAssertTrue(mockNetworkManager.performRequestCalled)
    }
    
    func testGetMovieDetailsFailure() {
        // Given
        let movieId = 123
        let error = NetworkError.invalidResponse
        mockNetworkManager.mockDetailResult = .failure(error)
        
        // When
        movieService.getMovieDetails(movieId: movieId) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let networkError):
                XCTAssertEqual(networkError, error)
            }
        }
    }
    
    func testSearchMoviesWithDefaultPage() {
        // Given
        let query = "test"
        let mockResponse = MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 0)
        mockNetworkManager.mockSearchResult = .success(mockResponse)
        
        // When
        movieService.searchMovies(query: query) { _ in }
        
        // Then
        XCTAssertTrue(mockNetworkManager.performRequestCalled)
        // Should use default page 1
    }
    
    // MARK: - Helper Methods
    private func createMockMovie() -> Movie {
        return Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: "/test.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: 1000000,
            revenue: 5000000
        )
    }
    
    private func createMockMovieDetail() -> MovieDetail {
        return MovieDetail(
            id: 123,
            title: "Test Movie Detail",
            originalTitle: "Test Movie Detail Original",
            overview: "Test detail overview",
            posterPath: "/test_detail.jpg",
            backdropPath: "/test_detail_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 9.0,
            voteCount: 2000,
            budget: 2000000,
            revenue: 10000000,
            runtime: 120,
            genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Adventure")],
            productionCompanies: [ProductionCompany(id: 1, name: "Test Studio", logoPath: nil, originCountry: "US")]
        )
    }
}

 