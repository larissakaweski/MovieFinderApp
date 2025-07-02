//
//  NetworkManager.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func performRequest<T: Codable>(_ serviceRequest: ServiceRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private var currentTask: URLSessionDataTask?
    
    private init() {}
    
    // MARK: - Generic Network Request
    func performRequest<T: Codable>(_ serviceRequest: ServiceRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard APIConfig.isConfigured else {
            completion(.failure(.serverError("API Key não configurada. Configure sua API Key no arquivo APIConfig.swift")))
            return
        }
        
        var urlComponents = URLComponents(string: "\(serviceRequest.baseUrl)\(serviceRequest.fullPath)")
        
        if let queryParams = serviceRequest.queryParams {
            urlComponents?.queryItems = queryParams.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = serviceRequest.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15
        
        currentTask?.cancel()
        
        currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                
                self?.currentTask = nil
                
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        
        currentTask?.resume()
    }
} 
