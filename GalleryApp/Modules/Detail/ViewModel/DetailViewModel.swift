//
//  DetailViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation

protocol DetailViewModelProtocol {
    var numberOfItems: Int { get }
    var delegate: RequestDelegate? { get set }
    func getDetailCellViewModel(at indexPath: IndexPath) -> DetailCellViewModel
    func getCurrentItemIndexPath() -> IndexPath
    func refreshData()
}

class DetailViewModel: DetailViewModelProtocol {

    private var indexPath: IndexPath
    private var detailCellViewModels: [DetailCellViewModel]
    
    weak var delegate: RequestDelegate?
    
    private var viewState: ViewState {
        // When viewState is changed, notify about it MainViewController
        didSet {
            self.delegate?.didUpdate(with: viewState)
        }
    }

    init(indexPath: IndexPath, detailCellViewModels: [DetailCellViewModel]) {
        self.viewState = .idle
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
    
    func refreshData() {
        self.viewState = .success
    }
}
