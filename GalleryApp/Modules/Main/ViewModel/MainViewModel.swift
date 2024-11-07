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
    case idle
    // Error States
    case noInternetConnection
    case missingPermissions
    case invalidAccessToken
    case serverError
    case notSpecificError
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
        let detailCellViewModels = self.dataSource.map { item in
            var detailCellViewModel = DetailCellViewModel(item: item)
            if let date = fromStringToDateFormatter.date(from: detailCellViewModel.createdDate) {
                detailCellViewModel.createdDate = fromDateToStringFormatter.string(from: date)
            }
            return detailCellViewModel
        }
        return DetailViewModel(currentPage: currentPage,
                               indexPath: indexPath,
                               detailCellViewModels: detailCellViewModels)
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
            case .success(let photos):
                self.handleSuccessfullLoad(photos: photos)
            case .failure(let error):
                if let networkError = error as? NetworkError.ResponseError {
                    switch networkError {
                    case .missingPermissions:
                        self.viewState = .missingPermissions
                        
                    case .invalidAccessToken:
                        self.viewState = .invalidAccessToken
                    case .serverError, .notFound:
                        self.viewState = .serverError
                    case .urlRequestFailed, .unknownResponseError:
                        self.viewState = .notSpecificError
                    }
                } else if let error = error as? NetworkError {
                    self.loadFavouritePhotosFromCoreData()
                    self.viewState = .noInternetConnection
                } else {
                    self.viewState = .notSpecificError
                }
                
                guard let error = error as? NetworkError else {
                    return print(error.localizedDescription)
                }
                print(error.description)
            }
        }
    }
    
    private func handleSuccessfullLoad(photos: [PhotoItem]) {
        self.currentPage += 1
        self.dataSource.append(contentsOf: photos)
        self.mainViewModelCells.append(contentsOf: photos.map { MainCellViewModel(item: $0) })
        self.viewState = .success
    }
    
    private func loadFavouritePhotosFromCoreData() {
        CoreDataHelper.fetchData(onSuccess: { [weak self] fetchingPhotos in
            guard let self = self else { return }
            guard let fetchingPhotos = fetchingPhotos else { return }
            self.dataSource = fetchingPhotos.map { PhotoItem(coreDataItem: $0) }
            self.mainViewModelCells = self.dataSource.map { MainCellViewModel(item: $0) }
        })
    }
}
