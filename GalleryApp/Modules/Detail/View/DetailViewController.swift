//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 1.11.24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    private let viewModel: ViewModel
    private let indexPath: IndexPath
    
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
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
    
    init(viewModel: ViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImageViewFrame() -> CGRect {
        self.view.layoutIfNeeded()
        guard let layoutAttributes = collectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0)) else {
            return CGRect(x: 100, y: 100, width: 50, height: 50)
        }
        
        let cellFrameInCollectionView = layoutAttributes.frame
        let cellFrameInSuperview = collectionView.convert(cellFrameInCollectionView, to: self.view)
        let imageViewSize = CGSize(width: cellFrameInSuperview.width,
                                   height: cellFrameInSuperview.height * 0.65)
        let imageViewOriginX = cellFrameInSuperview.origin.x + 16
        let imageViewOriginY = cellFrameInSuperview.origin.y +
        (cellFrameInSuperview.height - imageViewSize.height) / 2 + 12
        
        let imageViewFrameInSuperview = CGRect(origin: CGPoint(x: imageViewOriginX, y: imageViewOriginY), size: imageViewSize)
        
        let imageInSuperview = getImageCoordinatesInSuperview(imageViewFrame: imageViewFrameInSuperview,
                                                              imageSize: self.viewModel.getSize(for: indexPath))
        print("imageViewFrameInSuperview \(imageViewFrameInSuperview)")
        return imageInSuperview
        
    }
    
    private func getImageCoordinatesInSuperview(imageViewFrame: CGRect, imageSize: CGSize) -> CGRect {
        let imageViewWidth = imageViewFrame.size.width
        let imageViewHeight = imageViewFrame.size.height
        
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height

        let imageViewRatio = imageViewWidth / imageViewHeight
        let imageRatio = imageWidth / imageHeight
        
        var scale: CGFloat
        var scaledImageSize: CGSize
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        if imageViewRatio > imageRatio {
            scale = imageViewHeight / imageHeight
            scaledImageSize = CGSize(width: imageWidth * scale, height: imageViewHeight)
            xOffset = (imageViewWidth - scaledImageSize.width) / 2
        } else {
            scale = imageViewWidth / imageWidth
            scaledImageSize = CGSize(width: imageViewWidth, height: imageHeight * scale)
            yOffset = (imageViewHeight - scaledImageSize.height) / 2
        }

        let imageX = imageViewFrame.origin.x + xOffset
        let imageY = imageViewFrame.origin.y + yOffset
        let imageRect = CGRect(x: imageX, y: imageY, width: scaledImageSize.width, height: scaledImageSize.height)

        return imageRect
    }
}

extension DetailViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), 
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                               heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 8.0)
        
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
        
        if let url = self.viewModel.getUrl(photoType: .regular, for: indexPath) {
            self.viewModel.loadImage(url: url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.configureCell(description:  self.viewModel.getDescription(for: indexPath),
                                                    image: image,
                                                    isFavorite: self.viewModel.getFavoriteStatus(for: indexPath))
                    }
                }
            }
        }
        return cell
    }
}
