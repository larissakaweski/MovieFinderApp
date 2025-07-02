//
//  String+Extensions.swift
//  MovieFinder
//
//  Created by Larissa Kaweski Siqueira on 29/06/25.
//

import Foundation

extension String {
    /// Converte uma string no formato "yyyy-MM-dd" para "dd/MM/yyyy" (padrão brasileiro).
    func formattedDateBR() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else { return self }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        outputFormatter.locale = Locale(identifier: "pt_BR")
        return outputFormatter.string(from: date)
    }
} 
