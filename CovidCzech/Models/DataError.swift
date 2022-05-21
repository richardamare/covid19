//
//  DataError.swift
//  CovidCzech
//
//  Created by Richard Amare on 5/21/22.
//

import Foundation

enum DataError: Error {
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
