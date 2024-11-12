//
//  ViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 28.10.24.
//

import Foundation
import UIKit

enum ViewState {
    case isLoading
    case success
    case error
    case idle
}

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}

protocol MainViewModelProtocol {
    var delegate: RequestDelegate? { get set }
    var numberOfItems: Int { get }
    func loadPhotos()
    func performFullRefresh()
    func getRatio(for indexPath: IndexPath) -> CGFloat
    func shouldRequestNextPages() -> Bool
    func prepareDetailViewModel(at indexPath: IndexPath) -> DetailViewModel
    func getMainCellViewModel(at indexPath: IndexPath) -> MainCellViewModel?
    func showFavourite()
}

final class MainViewModel {
    
    // Request data page-by-page (30 photos on each page)
    private var currentPage = 1
    private var shouldRequestNextPage = true
    private var showFavouriteMode = false
    weak var delegate: RequestDelegate?
    
    private var networkManager: NetworkManagerProtocol
    
    private var viewState: ViewState {
        // When viewState is changed, notify about it MainViewController
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }
    
    private var dataSource: [PhotoItem] = []
    private var mainViewModelCells: [MainCellViewModel] = []

    init(networkManager: NetworkManagerProtocol) {
        self.viewState = .idle
        self.networkManager = networkManager
    }
}

// MARK: DataSource
extension MainViewModel: MainViewModelProtocol {
    
    var numberOfItems: Int {
        self.mainViewModelCells.count
    }
    
    func getMainCellViewModel(at indexPath: IndexPath) -> MainCellViewModel? {
        guard indexPath.row < self.mainViewModelCells.count else {
            return nil
        }
        return self.mainViewModelCells[indexPath.row]
    }
    
    func prepareDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let detailCellViewModels = self.dataSource.map { item in
            let detailCellViewModel = DetailCellViewModel(item: item)
            if let date = DateFormatter.fromStringToDateFormatter.date(from: detailCellViewModel.createdDate) {
                detailCellViewModel.createdDate = DateFormatter.fromDateToStringFormatter.string(from: date)
            }
            return detailCellViewModel
        }
        return DetailViewModel(indexPath: indexPath,
                               detailCellViewModels: detailCellViewModels)
    }
 
    func getRatio(for indexPath: IndexPath) -> CGFloat {
        if self.dataSource[indexPath.row].width > 0 && self.dataSource[indexPath.row].height > 0 {
            return CGFloat(self.dataSource[indexPath.row].height) / CGFloat(self.dataSource[indexPath.row].width)
        } else {
            debugPrint("""
                  Invalid dimensions for photo at index \(indexPath):
                  height = \(self.dataSource[indexPath.row].height),
                  width = \(self.dataSource[indexPath.row].width)
                  """)
            return 1.0
        }
    }
    
    func shouldRequestNextPages() -> Bool {
        self.shouldRequestNextPage
    }
}

// MARK: Setup Data Loading
extension MainViewModel {
    
    func showFavourite() {
        self.showFavouriteMode.toggle()
        
        if self.showFavouriteMode {
            self.loadFavouritePhotosFromCoreData()
            self.shouldRequestNextPage = false
        } else {
            self.performFullRefresh()
            self.shouldRequestNextPage = true
        }
        self.viewState = .success
    }

    func performFullRefresh() {
        self.currentPage = 1
        self.dataSource.removeAll()
        self.mainViewModelCells.removeAll()
        self.loadPhotos()
    }
    
    func loadPhotos() {
        guard viewState != .isLoading else { return }
        self.viewState = .isLoading
        self.networkManager.getPhotos(currentPage: self.currentPage) { result in
            switch result {
            case .success(let photos):
                self.handleSuccessfullLoad(photos: photos)
            case .failure(let error):
                self.viewState = .error
                self.loadFavouritePhotosFromCoreData()
                
                guard let error = error as? NetworkError else {
                    return debugPrint(error.localizedDescription)
                }
                debugPrint(error.description)
            }
        }
    }
    
    private func handleSuccessfullLoad(photos: [PhotoItem]) {
        self.currentPage += 1
        self.dataSource.append(contentsOf: photos)
        self.mainViewModelCells.append(contentsOf: photos.map { MainCellViewModel(item: $0) })
        self.viewState = .success
        self.shouldRequestNextPage = true
    }
    
    private func loadFavouritePhotosFromCoreData() {
        // swiftlint:disable:next trailing_closure
        CoreDataHelper.fetchData(onSuccess: { [weak self] fetchingPhotos in
            guard let self = self else { return }
            guard let fetchingPhotos = fetchingPhotos else { return }
            self.dataSource = fetchingPhotos.map { PhotoItem(coreDataItem: $0) }
            self.mainViewModelCells = self.dataSource.map { MainCellViewModel(item: $0) }
            self.showFavouriteMode = true
            self.shouldRequestNextPage = false
        })
    }
}
