//
//  NetworkError.swift
//  AirQuality
//
//  Created by Tasuku Yamamoto on 4/27/22.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case invalidURL
    case throwError(Error)
    case noData
    case unableToDecode(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the necessary URL."
        case .throwError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server responded with no data."
        case .unableToDecode(let error):
            return "Unable to decode the data. \(error.localizedDescription) -- \(error)"
            
        }
    }
    
    
    
}//End of enum
