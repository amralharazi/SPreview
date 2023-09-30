//
//  NetworkError.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case noConnection
}


extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "The provided URL seems invalid."
        case .invalidServerResponse:
            return "Couldn't parse recieved data."
        case .noConnection:
            return "Seems like there is no internet connection."
        }
    }
}
