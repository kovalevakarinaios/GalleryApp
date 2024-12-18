//
//  NetworkManager.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import Foundation
import Network

protocol NetworkManagerProtocol {
    func getPhotos(currentPage: Int, completion: @escaping (Result<[PhotoItem], Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {

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
            return nil
        }
        // Passing the accessKey to the request's header
        urlRequest.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    // General Logic of network request
    private func handleRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = createRequest(url: url) else {
            completion(.failure(NetworkError.urlRequestFailed))
            return
        }
        
        self.checkInternetConnection { isConnected in
            
            guard isConnected else {
                return completion(.failure(NetworkError.noInternetConnection))
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        break
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
                        // swiftlint:disable:next line_length
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
    }
    
    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global()

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
            monitor.cancel()
        }
        monitor.start(queue: queue)
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
}
