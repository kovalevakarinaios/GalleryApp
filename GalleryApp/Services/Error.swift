//
//  Error.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 7.11.24.
//

import Foundation

// List of errors that may occur when working with the network
enum NetworkError: Error {
    case invalidURL
    case urlRequestFailed
    case noData
    case decodingError
    case invalidResponse
    case noInternetConnection
    
    enum ResponseError: Error {
        case missingPermissions
        case urlRequestFailed
        case invalidAccessToken
        case serverError
        case notFound
        case unknownResponseError(statusCode: Int)
        
        var description: String {
            switch self {
            case .missingPermissions:
                return "Missing permissions to perform request"
            case .urlRequestFailed:
                return "The request was unacceptable, ex. due to missing a required parameter"
            case .invalidAccessToken:
                return "Invalid Access Token"
            case .serverError:
                return "Something went wrong on server side"
            case .notFound:
                return "The requested resource doesn’t exist"
            case .unknownResponseError(let statusCode):
                return "Other response error, statusCode - \(statusCode)"
            }
        }
    }
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URL is invalid"
        case .urlRequestFailed:
            return "URL request is failed"
        case .noData:
            return "Data could not be received from the server"
        case .decodingError:
            return "Decoding Error"
        case .invalidResponse:
            return "Response is invalid"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
