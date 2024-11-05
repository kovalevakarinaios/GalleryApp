//
//  NetworkManager.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import Foundation

// List of errors that may occur when working with the network
enum NetworkError: Error {
    case invalidURL
    case urlRequestFailed
    case noData
    case decodingError
    case invalidResponse
    
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
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private func createURL(currentPage: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "per_page", value: "30"),
            
        ]
        return components.url
    }
    
    private func createRequest(url: URL) -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        // Getting the accessKey from Info.plist
        guard let accessKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashAccessKey") as? String else {
            print("The access key was not found in Info.plist")
            return nil
        }
        // Passing the accessKey to the request's header
        urlRequest.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    // General Logic of network request
    private func handleRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = createRequest(url: url) else {
            print("Error - \(NetworkError.urlRequestFailed.description)")
            completion(.failure(NetworkError.urlRequestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    print("Response is successfull")
                case 400:
                    completion(.failure(NetworkError.ResponseError.urlRequestFailed))
                case 401:
                    completion(.failure(NetworkError.ResponseError.invalidAccessToken))
                case 403:
                    completion(.failure(NetworkError.ResponseError.missingPermissions))
                case 404:
                    completion(.failure(NetworkError.ResponseError.notFound))
                case 500...599:
                    completion(.failure(NetworkError.ResponseError.serverError))
                default:
                    completion(.failure(NetworkError.ResponseError.unknownResponseError(statusCode: response.statusCode)))
                }
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    func getPhotos(currentPage: Int, completion: @escaping (Result<[PhotoItem], Error>) -> Void) {
        
        guard let url = createURL(currentPage: currentPage) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        self.handleRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode([PhotoItem].self, from: data)
                    completion(.success(decodedData))
                } catch let decodingError {
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        self.handleRequest(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
