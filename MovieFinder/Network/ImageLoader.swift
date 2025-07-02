//
//  ImageLoader.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 29/06/25.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = URLCache.shared
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        self.session = URLSession(configuration: config)
    }
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }

        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            completion(image)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
                if let data, let image = UIImage(data: data) {
                    if let response {
                        let cachedResponse = CachedURLResponse(response: response, data: data)
                        self?.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                    }
                    completion(image)
                } else {
                    completion(nil)
                }
        }
        task.resume()
    }
    
    func loadImage(from url: URL?, into imageView: UIImageView, placeholder: UIImage? = nil) {
        imageView.image = placeholder
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadImage(from: url) { image in
                DispatchQueue.main.async { 
                    imageView.image = image ?? placeholder
                }
            }
        }
    }
    
    func clearCache() {
        cache.removeAllCachedResponses()
    }
} 
