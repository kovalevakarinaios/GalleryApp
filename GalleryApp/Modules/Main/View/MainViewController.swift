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
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupDelegates()
        self.viewModel.loadPhotos()
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(self.updateData))
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

    private func showAlertController(title: String, message: String) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Repeat Again",
                                                style: .default) { _ in
            self.viewModel.loadPhotos()
        })
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel) { _ in
            self.collectionView.reloadData()
        })
        self.present(alertController, animated: true)
    }
    
    @objc 
    func updateData() {
        self.viewModel.performFullRefresh()
        self.collectionView.setContentOffset(.zero, animated: true)
    }
}

// Вынести в CellViewModel
extension MainViewController: GalleryLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        self.viewModel.getRatio(for: indexPath)
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

    // Load data when we have almost reached the end of CV in Online Mode
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.numberOfItems - 4 && !self.viewModel.checkOfflineStatus() {
            self.viewModel.loadPhotos()
        }
    }
}

// MARK: RequestDelegate - ViewModel
extension MainViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoading:
                print("View is loading")
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            case .success:
                self.collectionView.reloadData()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            case .idle:
                break
            case .noInternetConnection:
                self.showAlertController(title: "No Internet Connection",
                                         message: """
                                         There is no internet connection.
                                         Please check your connection and try again.
                                         """)
            case .missingPermissions:
                self.showAlertController(title: "Insufficient Permissions to Access Content",
                                         message: """
                                         At the moment, you do not have sufficient permissions to access this content. 
                                         Please contact your administrator.
                                         """)
            case .invalidAccessToken:
                self.showAlertController(title: "Authorization Error",
                                         message: "Please refresh your token and try again.")
            case .serverError:
                self.showAlertController(title: "Server Error",
                                         message: "The server is not responding. Please try again later.")
            case .notSpecificError:
                self.showAlertController(title: "Something Went Wrong",
                                         message: "Something went wrong. Please try again.")
            }
        }
    }
}
