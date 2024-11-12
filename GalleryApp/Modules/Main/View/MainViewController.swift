//
//  ViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 26.10.24.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let customNavigationDelegate = CustomNavigationControllerDelegate()
    private var viewModel: MainViewModelProtocol

    private lazy var collectionView: UICollectionView = {
        let layout = GalleryLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(MainPhotoCell.self, forCellWithReuseIdentifier: MainPhotoCell.identifier)
        // swiftlint:disable:next line_length
        collectionView.register(PlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: PlaceholderCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupDelegates()
        self.viewModel.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // Reset attributes cache when screen orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // swiftlint:disable:next trailing_closure
        coordinator.animate(alongsideTransition: { _ in
            if let layout = self.collectionView.collectionViewLayout as? GalleryLayout {
                layout.removeCache()
                layout.invalidateLayout()
            }
        })
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(self.updateData))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.showFavourite))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemGray
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
            self.viewModel.performFullRefresh()
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
    
    @objc
    func showFavourite() {
        guard let leftButton = self.navigationItem.leftBarButtonItem else { return }
        guard let rightButton = self.navigationItem.rightBarButtonItem else { return }
        
        leftButton.isSelected.toggle()
        
        if leftButton.isSelected {
            leftButton.tintColor = .red
            rightButton.isEnabled = false
        } else {
            leftButton.tintColor = .systemGray
            rightButton.isEnabled = true
        }

        self.viewModel.showFavourite()
    }
}

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
        guard let model = self.viewModel.getMainCellViewModel(at: indexPath) else {
            // swiftlint:disable:next line_length
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceholderCollectionViewCell.identifier,
                                                                for: indexPath) as? PlaceholderCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        cell.configureCell(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(viewModel: self.viewModel.prepareDetailViewModel(at: indexPath))
        if let cell = collectionView.cellForItem(at: indexPath) {
            // Convert сell frame to frame relative to superview
            let originFrame = cell.superview?.convert(cell.frame, to: nil) ?? .zero
            let snapshot = cell.snapshotView(afterScreenUpdates: true) ?? UIView()
            // swiftlint:disable:next line_length
            customNavigationDelegate.updateInfoForTransitionAnimation(cellOriginFrame: originFrame, snapshot: snapshot, frame: detailViewController.getImageViewFrame(ratio: self.viewModel.getRatio(for: indexPath)))
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    // Load data when we have almost reached the end of CV in Online Mode
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.numberOfItems - 4 && self.viewModel.shouldRequestNextPages() {
            self.viewModel.loadPhotos()
        }
    }
}

// MARK: RequestDelegate - ViewModel
extension MainViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoading, .idle:
                break
            case .success:
                self.collectionView.reloadData()
            case .error:
                self.showAlertController(title: "Something Went Wrong",
                                         message: "Something went wrong. Please try again.")
            }
        }
    }
}
