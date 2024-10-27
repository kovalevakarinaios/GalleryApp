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
    case requestFailed
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private func createURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
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
    
    func getPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = createURL() else {
            completion(.failure(NetworkError.invalidURL))
            return }
        
        guard let urlRequest = createRequest(url: url) else {
            completion(.failure(NetworkError.requestFailed))
            return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            
            if let response = response {

            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
