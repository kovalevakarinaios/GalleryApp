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
    
    func getPhotos(currentPage: Int, completion: @escaping (Result<[PhotoItem], Error>) -> Void) {
        
        guard let url = createURL(currentPage: currentPage) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let urlRequest = createRequest(url: url) else {
            completion(.failure(NetworkError.urlRequestFailed))
            return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([PhotoItem].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
       
        guard let urlRequest = createRequest(url: url) else {
            completion(.failure(NetworkError.urlRequestFailed))
            return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
