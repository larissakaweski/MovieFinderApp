//
//  Number+CurrencyFormat.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 28/06/25.
//

import Foundation

// MARK: - Currency Formatting Extensions

extension Int {
    
    /// Formata um valor inteiro como moeda em dólares americanos
    /// - Returns: String formatada como moeda (ex: "$1,234,567")
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
