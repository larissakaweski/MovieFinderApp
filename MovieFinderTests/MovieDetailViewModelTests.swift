//
//  MovieDetailViewModelTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import XCTest
@testable import MovieFinder

class MovieDetailViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailViewModel!
    var mockDelegate: MockMovieDetailViewModelDelegate!
    var mockMovieService: MockMovieService!
    var mockFavoritesService: MockFavoritesService!
    var testMovie: Movie!
    
    override func setUp() {
        super.setUp()
        testMovie = createMockMovie()
        mockMovieService = MockMovieService()
        mockFavoritesService = MockFavoritesService()
        mockDelegate = MockMovieDetailViewModelDelegate()
        
        viewModel = MovieDetailViewModel(
            movie: testMovie,
            movieService: mockMovieService,
            favoritesService: mockFavoritesService
        )
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        mockMovieService = nil
        mockFavoritesService = nil
        testMovie = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.currentMovie.id, testMovie.id)
        XCTAssertEqual(viewModel.currentMovie.title, testMovie.title)
        XCTAssertFalse(viewModel.isFavorite)
    }
    
    func testLoadMovieDetailsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Load movie details success")
        let mockDetail = createMockMovieDetail()
        mockMovieService.mockDetailResult = .success(mockDetail)
        mockFavoritesService.isFavoriteResult = true
        
        // When
        viewModel.loadMovieDetails()
        
        // Simulate async completion
        DispatchQueue.main.async {
            self.mockMovieService.completeDetailRequest()
            
            // Then
            DispatchQueue.main.async {
                XCTAssertTrue(self.mockMovieService.getMovieDetailsCalled)
                XCTAssertEqual(self.mockMovieService.lastMovieId, self.testMovie.id)
                XCTAssertTrue(self.mockDelegate.didStartLoadingCalled)
                XCTAssertTrue(self.mockDelegate.didStopLoadingCalled)
                XCTAssertTrue(self.mockDelegate.didLoadMovieDetailsCalled)
                XCTAssertEqual(self.mockDelegate.lastLoadedMovie?.id, mockDetail.id)
                XCTAssertTrue(self.mockDelegate.lastIsFavorite)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadMovieDetailsWhenAlreadyLoading() {
        // Given
        mockMovieService.shouldDelayCompletion = true
        viewModel.loadMovieDetails()
        
        // When - try to load again while loading
        viewModel.loadMovieDetails()
        
        // Then
        XCTAssertEqual(mockMovieService.getMovieDetailsCallCount, 1)
    }
    
    func testToggleFavoriteAdd() {
        // Given
        mockFavoritesService.isFavoriteResult = false
        
        // When
        viewModel.toggleFavorite()
        
        // Then
        XCTAssertTrue(mockFavoritesService.addToFavoritesCalled)
        XCTAssertEqual(mockFavoritesService.lastAddedMovie?.id, testMovie.id)
        XCTAssertTrue(mockDelegate.didUpdateFavoriteStatusCalled)
        XCTAssertTrue(mockDelegate.lastFavoriteStatus)
    }
    
    func testToggleFavoriteRemove() {
        // Given
        mockFavoritesService.isFavoriteResult = true
        
        // When
        viewModel.toggleFavorite()
        
        // Then
        XCTAssertTrue(mockFavoritesService.removeFromFavoritesCalled)
        XCTAssertEqual(mockFavoritesService.lastRemovedMovie?.id, testMovie.id)
        XCTAssertTrue(mockDelegate.didUpdateFavoriteStatusCalled)
        XCTAssertFalse(mockDelegate.lastFavoriteStatus)
    }
    
    func testIsFavorite() {
        // Given
        mockFavoritesService.isFavoriteResult = true
        
        // When
        let result = viewModel.isFavorite
        
        // Then
        XCTAssertTrue(result)
        XCTAssertTrue(mockFavoritesService.isFavoriteCalled)
        XCTAssertEqual(mockFavoritesService.lastCheckedMovie?.id, testMovie.id)
    }
    
    func testCurrentMovieWithDetail() {
        // Given
        let expectation = XCTestExpectation(description: "Current movie with detail")
        let mockDetail = createMockMovieDetail()
        mockMovieService.mockDetailResult = .success(mockDetail)
        
        // When
        viewModel.loadMovieDetails()
        
        DispatchQueue.main.async {
            self.mockMovieService.completeDetailRequest()
            
            // Then
            DispatchQueue.main.async {
                XCTAssertEqual(self.viewModel.currentMovie.id, mockDetail.id)
                XCTAssertEqual(self.viewModel.currentMovie.title, mockDetail.title)
                XCTAssertEqual(self.viewModel.currentMovie.budget, mockDetail.budget)
                XCTAssertEqual(self.viewModel.currentMovie.revenue, mockDetail.revenue)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCurrentMovieWithoutDetail() {
        // Then
        XCTAssertEqual(viewModel.currentMovie.id, testMovie.id)
        XCTAssertEqual(viewModel.currentMovie.title, testMovie.title)
        XCTAssertEqual(viewModel.currentMovie.budget, testMovie.budget)
        XCTAssertEqual(viewModel.currentMovie.revenue, testMovie.revenue)
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
            id: 1,
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

// MARK: - Mock Delegate
class MockMovieDetailViewModelDelegate: MovieDetailViewModelDelegate {
    var didLoadMovieDetailsCalled = false
    var didUpdateFavoriteStatusCalled = false
    var didShowErrorCalled = false
    var didStartLoadingCalled = false
    var didStopLoadingCalled = false
    
    var lastLoadedMovie: Movie?
    var lastIsFavorite: Bool = false
    var lastFavoriteStatus: Bool = false
    var errorMessage: String?
    
    func didLoadMovieDetails(_ movie: Movie, isFavorite: Bool) {
        didLoadMovieDetailsCalled = true
        lastLoadedMovie = movie
        lastIsFavorite = isFavorite
    }
    
    func didUpdateFavoriteStatus(_ isFavorite: Bool) {
        didUpdateFavoriteStatusCalled = true
        lastFavoriteStatus = isFavorite
    }
    
    func didShowError(_ message: String) {
        didShowErrorCalled = true
        errorMessage = message
    }
    
    func didStartLoading() {
        didStartLoadingCalled = true
    }
    
    func didStopLoading() {
        didStopLoadingCalled = true
    }
} 
