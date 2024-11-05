//
//  ViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 26.10.24.
//

import UIKit

class MainViewController: UIViewController {
    
    private let customNavigationDelegate = CustomNavigationControllerDelegate()
    // Think about refactoring (D)
    private let viewModel = MainViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = GalleryLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(MainPhotoCell.self, forCellWithReuseIdentifier: MainPhotoCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupCollectionView()
        self.setupDelegates()
        self.viewModel.loadPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setupDelegates() {
        self.viewModel.delegate = self
        self.navigationController?.delegate = self.customNavigationDelegate
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
// Вынести в CellViewModel
extension MainViewController: GalleryLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        self.viewModel.getRatio(for: indexPath)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height * 1.2) {
            self.viewModel.loadPhotos()
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPhotoCell.identifier,
                                                            for: indexPath) as? MainPhotoCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: self.viewModel.getMainCellViewModel(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(viewModel: self.viewModel.prepareDetailViewModel(at: indexPath))
        if let cell = collectionView.cellForItem(at: indexPath) {
            // Convert сell frame to frame relative to superview
            let originFrame = cell.superview?.convert(cell.frame, to: nil) ?? .zero
            let snapshot = cell.snapshotView(afterScreenUpdates: true) ?? UIView()
            
            customNavigationDelegate.updateInfoForTransitionAnimation(cellOriginFrame: originFrame,
                                                                      snapshot: snapshot,
                                                                      frame: detailViewController.getImageViewFrame())
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: RequestDelegate - ViewModel
extension MainViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoading:
                // showLoadingIndicator
                print("showLoadingIndicatorOnMainScreenInsteadOfCollectionView")
            case .success:
                print("Success")
                self.collectionView.reloadData()
            case .error:
                // showAlertController
                print("showAlertController")
            case .idle:
                break
            }
        }
    }
}
