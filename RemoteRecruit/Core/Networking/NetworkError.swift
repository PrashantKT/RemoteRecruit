//
//  NetworkError.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

protocol MessageError: Error {
    var userFriendlyMessage: String { get }
}

enum NetworkError: MessageError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case networkUnavailable
    case unknown


    var userFriendlyMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpError(let statusCode):
            return "Server error (\(statusCode))."
        case .decodingError:
            return "Unable to process server data."
        case .unknown:
            return "Something went wrong."
        case .networkUnavailable:
            return "Please check your internet connection."
        }
    }
}
