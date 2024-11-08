//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 1.11.24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.viewModel.delegate = self
        self.viewModel.refreshData()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),
            self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImageViewFrame(ratio: CGFloat) -> CGRect {
        self.view.layoutIfNeeded()
        guard let layoutAttributes = collectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0)) else {
            return CGRect(x: 100, y: 100, width: 50, height: 50)
        }
        
        let cellFrameInCollectionView = layoutAttributes.frame
        let cellFrameInSuperview = collectionView.convert(cellFrameInCollectionView, to: self.view)
        let imageViewWidth = cellFrameInSuperview.width * 0.81
        let imageViewHeight = imageViewWidth * ratio
        let imageViewSize = CGSize(width: imageViewWidth,
                                   height: imageViewHeight)
        let imageViewOriginX = cellFrameInSuperview.origin.x + (cellFrameInSuperview.width - imageViewSize.width) / 2
        let imageViewOriginY = cellFrameInSuperview.origin.y + (cellFrameInSuperview.height - imageViewSize.height) / 2
        
        let imageViewFrameInSuperview = CGRect(origin: CGPoint(x: imageViewOriginX, 
                                                               y: imageViewOriginY),
                                               size: imageViewSize)
        return imageViewFrameInSuperview
    }
}

extension DetailViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), 
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCell.identifier,
                                                            for: indexPath) as? DetailPhotoCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: self.viewModel.getDetailCellViewModel(at: indexPath))
        return cell
    }
}

// MARK: RequestDelegate - ViewModel
extension DetailViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoading:
                print("DetailVC is loading")
            case .success:
                print("DetailVC loading is successfull")
                self.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.collectionView.scrollToItem(at: self.viewModel.getCurrentItemIndexPath(),
                                                     at: .centeredVertically,
                                                     animated: true)
                }
            default:
                let alertController = UIAlertController(title: "Something Went Wrong",
                                                        message: "Something went wrong. Please try again.",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel",
                                                        style: .cancel))
                self.present(alertController, animated: true)
            }
        }
    }
}
