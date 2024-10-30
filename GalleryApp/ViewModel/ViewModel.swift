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

enum ViewState {
    case isLoading
    case success
    case error
    case idle
}

class ViewModel {
    
    weak var delegate: RequestDelegate?
    
    private var viewState: ViewState {
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }
    
    private var photos: [Photo] = []
    
    init() {
        self.viewState = .idle
    }
}

// MARK: DataSource
extension ViewModel {
    var numberOfItems: Int {
        self.photos.count
    }
    
    func getThumbUrl(for indexPath: IndexPath) -> URL? {
        guard let url = URL(string: self.photos[indexPath.row].urls.thumb) else {
            return nil
        }
        return url
    }
    
    func getRatio(for indexPath: IndexPath) -> CGFloat {
        CGFloat(self.photos[indexPath.row].height) / CGFloat(self.photos[indexPath.row].width)
    }
}

// MARK: Setup Data Loading
extension ViewModel {
    func loadPhotos() {
        self.viewState = .isLoading
        NetworkManager.shared.getPhotos { result in
            switch result {
            case .success(let success):
                self.photos = success
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
                print("Cell success")
            case .failure(let failure):
                print("Cell failure - \(failure)")
            }
        }
    }
}
