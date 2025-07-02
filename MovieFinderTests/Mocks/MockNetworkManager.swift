import Foundation
@testable import MovieFinder

class MockNetworkManager: NetworkManagerProtocol {
    var performRequestCalled = false
    var lastRequest: ServiceRequest?
    var mockResult: Result<Data, NetworkError>?
    var shouldDelayCompletion = false
    var mockSearchResult: Result<MovieResponse, NetworkError>?
    var mockDetailResult: Result<MovieDetail, NetworkError>?
    
    func performRequest<T>(_ request: ServiceRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        performRequestCalled = true
        lastRequest = request
        
        if !shouldDelayCompletion {
            DispatchQueue.main.async {
                self.completeRequest(completion: completion)
            }
        }
    }
    
    func performRequestWithSpecificResult<T>(_ request: ServiceRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        performRequestCalled = true
        lastRequest = request
        
        switch request {
        case .searchMovies:
            if let result = mockSearchResult as? Result<T, NetworkError> {
                completion(result)
            }
        case .getMovieDetails:
            if let result = mockDetailResult as? Result<T, NetworkError> {
                completion(result)
            }
        }
    }
    
    func completeRequest<T>(completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        // First try to use specific results
        switch T.self {
        case is MovieResponse.Type:
            if let result = mockSearchResult as? Result<T, NetworkError> {
                completion(result)
                return
            }
        case is MovieDetail.Type:
            if let result = mockDetailResult as? Result<T, NetworkError> {
                completion(result)
                return
            }
        default:
            break
        }
        
        // Fallback to generic mock result
        guard let mockResult = mockResult else {
            completion(.failure(.serverError("No mock result set")))
            return
        }
        
        switch mockResult {
        case .success(let data):
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serverError("Decoding error: \(error.localizedDescription)")))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func reset() {
        performRequestCalled = false
        lastRequest = nil
        mockResult = nil
        shouldDelayCompletion = false
    }
} 