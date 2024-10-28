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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: flowLayout)
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
        self.viewModel.loadData()
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
