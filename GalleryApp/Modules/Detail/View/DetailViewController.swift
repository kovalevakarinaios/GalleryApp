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
    
    private lazy var handler: UIButton.ConfigurationUpdateHandler = { button in
        switch button.state {
        case .selected:
            button.configuration?.baseForegroundColor = .red
        default:
            button.configuration?.baseForegroundColor = .white
        }
        
    }
    
    private lazy var buttonConfiguration: UIButton.Configuration = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.baseBackgroundColor = .darkGray
        return buttonConfiguration
    }()
    
    private lazy var addToFavoriteButton: UIButton = {
        var addToFavoriteButton = UIButton(configuration: self.buttonConfiguration)
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        addToFavoriteButton.addTarget(self, action: #selector(self.addedToFavorite), for: .touchUpInside)
        addToFavoriteButton.configurationUpdateHandler = self.handler
        return addToFavoriteButton
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        return verticalStackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        return descriptionLabel
    }()
    
    private lazy var creationDateLabel: UILabel = {
        var creationDateLabel = UILabel()
        return creationDateLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupImageView()
        self.setupStackView()
        self.setupAddToFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
 
    private func setupImageView() {
        self.view.addSubview(self.imageView)
        
        if let url = self.viewModel.getThumbUrl(for: indexPath) {
            self.viewModel.loadImage(url: url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupAddToFavoriteButton() {
        self.view.addSubview(self.addToFavoriteButton)
        
        NSLayoutConstraint.activate([
            self.addToFavoriteButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -10),
            self.addToFavoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupStackView() {
        [self.descriptionLabel, self.creationDateLabel].forEach { self.verticalStackView.addArrangedSubview($0) }
        self.view.addSubview(self.verticalStackView)
        
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupLabels() {
//        self.descriptionLabel.text = self.viewModel[self.indexPath].getDe
    }
    
    @objc func addedToFavorite() {
        self.addToFavoriteButton.isSelected.toggle()
    }
    
    func getImageViewFrame() -> CGRect {
        self.view.layoutIfNeeded()
        return self.imageView.frame
    }
    
    init(viewModel: ViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
