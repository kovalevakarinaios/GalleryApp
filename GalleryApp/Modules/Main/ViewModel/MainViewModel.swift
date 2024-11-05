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

class MainViewModel {
    
    // Request data page-by-page (30 photos on each page)
    private var currentPage = 1
    weak var delegate: RequestDelegate?
    
    private var viewState: ViewState {
        // When viewState is changed, notify about it MainViewController
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }
    
    private var dataSource: [PhotoItem] = []
    private var mainViewModelCells: [MainCellViewModel] = []

    init() {
        self.viewState = .idle
    }
}

// MARK: DataSource
extension MainViewModel {
    var numberOfItems: Int {
        self.mainViewModelCells.count
    }
    
    func getMainCellViewModel(at indexPath: IndexPath) -> MainCellViewModel {
        self.mainViewModelCells[indexPath.row]
    }
    
    func prepareDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let detailCellViewModels = self.dataSource.map { DetailCellViewModel(item: $0) }
        return DetailViewModel(currentPage: currentPage,
                               indexPath: indexPath,
                               detailCellViewModels: detailCellViewModels)
    }
    
    // нужно ли
    func getUrl(photoType: PhotoType, for indexPath: IndexPath) -> URL? {
        switch photoType {
        case .regular:
            guard let url = URL(string: self.dataSource[indexPath.row].urls.regular) else {
                return nil
            }
            return url
        case .thumb:
            guard let url = URL(string: self.dataSource[indexPath.row].urls.thumb) else {
                return nil
            }
            return url
        }
    }

    // нужно ли
    func getRatio(for indexPath: IndexPath) -> CGFloat {
        CGFloat(self.dataSource[indexPath.row].height) / CGFloat(self.dataSource[indexPath.row].width)
    }
}
// MARK: Setup Data Loading
extension MainViewModel {
    func loadPhotos() {
        guard viewState != .isLoading else { return }
        
        self.viewState = .isLoading
        NetworkManager.shared.getPhotos(currentPage: self.currentPage) { result in
            switch result {
            case .success(let success):
                self.currentPage += 1
                self.dataSource.append(contentsOf: success)
                self.mainViewModelCells.append(contentsOf: success.map { MainCellViewModel(item: $0) })
                self.viewState = .success
            case .failure(let failure as NetworkError):
                print(failure.description)
                self.viewState = .error
            case .failure(_):
                self.viewState = .error
            }
        }
    }
}
