import Foundation
@testable import MovieFinder

class MockMovieService: MovieServiceProtocol {
    var searchMoviesCalled = false
    var searchMoviesCallCount = 0
    var lastQuery: String?
    var lastPage: Int?
    var mockSearchResult: Result<MovieResponse, NetworkError>?
    var shouldDelayCompletion = false
    var completionHandler: ((Result<MovieResponse, NetworkError>) -> Void)?
    
    // Additional properties for movie details
    var getMovieDetailsCalled = false
    var getMovieDetailsCallCount = 0
    var lastMovieId: Int?
    var mockDetailResult: Result<MovieDetail, NetworkError>?
    var detailCompletionHandler: ((Result<MovieDetail, NetworkError>) -> Void)?
    
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        searchMoviesCalled = true
        searchMoviesCallCount += 1
        lastQuery = query
        lastPage = page
        completionHandler = completion
        
        if !shouldDelayCompletion {
            DispatchQueue.main.async {
                self.completeSearch()
            }
        }
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        getMovieDetailsCalled = true
        getMovieDetailsCallCount += 1
        lastMovieId = movieId
        detailCompletionHandler = completion
        
        if !shouldDelayCompletion {
            DispatchQueue.main.async {
                self.completeDetailRequest()
            }
        }
    }
    
    func completeSearch() {
        guard let result = mockSearchResult, let completion = completionHandler else { return }
        completion(result)
    }
    
    func completeDetailRequest() {
        guard let result = mockDetailResult, let completion = detailCompletionHandler else { return }
        completion(result)
    }
} 