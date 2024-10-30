//
//  ViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 26.10.24.
//

import UIKit

class ViewController: UIViewController {
    
    // Think about refactoring (D)
    private let viewModel = ViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = GalleryLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupCollectionView()
        self.viewModel.delegate = self
        self.viewModel.loadPhotos()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ViewController: GalleryLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        self.viewModel.getRatio(for: indexPath)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height * 1.2) {
            self.viewModel.loadPhotos()
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                            for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        if let url = self.viewModel.getThumbUrl(for: indexPath) {
            self.viewModel.loadImage(url: url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.configureCell(image: image)
                    }
                }
                
            }
        }
        
        return cell
    }
}

// MARK: RequestDelegate - ViewModel
extension ViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoading:
                // showLoadingIndicator
                print("showLoadingIndicator")
            case .success:
                self.collectionView.reloadData()
                print("success")
            case .error:
                // showAlertController
                print("showAlertController")
            case .idle:
                break
            }
        }
    }
}
