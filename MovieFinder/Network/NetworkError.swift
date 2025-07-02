//
//  NetworkError.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "Nenhum dado recebido"
        case .decodingError:
            return "Erro ao decodificar dados"
        case .serverError(let message):
            return "Erro do servidor: \(message)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
} 