//
//  ViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 28.10.24.
//

import Foundation

// Нельзя сделать weak, если нет AnyObject
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
}

// MARK: Setup Data Loading
extension ViewModel {
    func loadData() {
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
}
