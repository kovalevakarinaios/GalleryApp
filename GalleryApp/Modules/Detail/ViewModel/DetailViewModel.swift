//
//  DetailViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation

class DetailViewModel {
    
    // Request data page-by-page (30 photos on each page)
    private var currentPage: Int
    private var indexPath: IndexPath
    private var detailCellViewModels: [DetailCellViewModel]
    
    weak var delegate: RequestDelegate?
    
    private var viewState: ViewState {
        // When viewState is changed, notify about it MainViewController
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }

   

    init(currentPage: Int, indexPath: IndexPath, detailCellViewModels: [DetailCellViewModel]) {
        self.viewState = .idle
        self.currentPage = currentPage
        self.indexPath = indexPath
        self.detailCellViewModels = detailCellViewModels
    }
}

// MARK: DataSource
extension DetailViewModel {
    
    var numberOfItems: Int {
        self.detailCellViewModels.count
    }
    
    func getDetailCellViewModel(at indexPath: IndexPath) -> DetailCellViewModel {
        self.detailCellViewModels[indexPath.row]
    }
    
    func getCurrentItemIndexPath() -> IndexPath {
        self.indexPath
    }
    
    func getSize() -> CGSize {
        CGSize(width: self.detailCellViewModels[self.indexPath.row].width,
               height: self.detailCellViewModels[self.indexPath.row].height)
    }
}

// MARK: Setup Data Loading
extension DetailViewModel {
    func loadPhotos() {
        guard viewState != .isLoading else { return }
        
        self.viewState = .isLoading
        NetworkManager.shared.getPhotos(currentPage: self.currentPage) { result in
            switch result {
            case .success(let success):
                self.currentPage += 1
                self.detailCellViewModels.append(contentsOf: success.map { DetailCellViewModel(item: $0) })
                self.viewState = .success
            case .failure(let failure):
                self.viewState = .error
            }
        }
    }
    
    func refreshData() {
        self.viewState = .success
    }
}
