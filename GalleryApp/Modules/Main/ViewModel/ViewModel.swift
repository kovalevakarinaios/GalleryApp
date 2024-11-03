//
//  ViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 28.10.24.
//

import Foundation
import UIKit

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}

enum PhotoType {
    case regular
    case thumb
}

enum ViewState {
    case isLoading
    case success
    case error
    case idle
}

class ViewModel {
    
    // Request data page-by-page (30 photos on each page)
    private var currentPage = 1
    weak var delegate: RequestDelegate?
    
    private var viewState: ViewState {
        // When viewState is changed, notify about it MainViewController
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }
    
    private var photos: [PhotoModel] = []
    
    init() {
        self.viewState = .idle
    }
}

// MARK: DataSource
extension ViewModel {
    var numberOfItems: Int {
        self.photos.count
    }
    
    func getUrl(photoType: PhotoType, for indexPath: IndexPath) -> URL? {
        switch photoType {
        case .regular:
            guard let url = URL(string: self.photos[indexPath.row].urls.regular) else {
                return nil
            }
            return url
        case .thumb:
            guard let url = URL(string: self.photos[indexPath.row].urls.thumb) else {
                return nil
            }
            return url
        }
    }
    
    func getDescription(for indexPath: IndexPath) -> String {
        self.photos[indexPath.row].generalDescription
    }
    
    func getRatio(for indexPath: IndexPath) -> CGFloat {
        CGFloat(self.photos[indexPath.row].height) / CGFloat(self.photos[indexPath.row].width)
    }
    
    func getSize(for indexPath: IndexPath) -> CGSize {
        CGSize(width: self.photos[indexPath.row].width, height: self.photos[indexPath.row].height)
    }
    
    func getFavoriteStatus(for indexPath: IndexPath) -> Bool {
        self.photos[indexPath.row].isFavorite
    }
}

// MARK: Setup Data Loading
extension ViewModel {
    func loadPhotos() {
        guard viewState != .isLoading else { return }
        
        self.viewState = .isLoading
        NetworkManager.shared.getPhotos(currentPage: self.currentPage) { result in
            switch result {
            case .success(let success):
                self.currentPage += 1
                success.forEach { self.photos.append(PhotoModel(id: $0.id,
                                                                createdAt: $0.createdAt,
                                                                generalDescription: $0.generalDescription,
                                                                urls: PhotoURLs(regular: $0.urls.regular, 
                                                                                thumb: $0.urls.thumb),
                                                                isFavorite: false,
                                                                width: $0.width,
                                                                height: $0.height))
                }
                self.viewState = .success
            case .failure(let failure):
                self.viewState = .error
            }
        }
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.downloadImage(url: url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure(let failure):
                print("Cell failure - \(failure)")
            }
        }
    }
}
