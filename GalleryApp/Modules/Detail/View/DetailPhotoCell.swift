//
//  DetailPhotoCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 3.11.24.
//

import Foundation
import UIKit

class DetailPhotoCell: UICollectionViewCell {
    
    static let identifier = "DetailPhotoCell"
    
    var cellViewModel: DetailCellViewModel?
    
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
        addToFavoriteButton.addTarget(self, action: #selector(self.tapFavouriteButton), for: .touchUpInside)
        addToFavoriteButton.configurationUpdateHandler = self.handler
        return addToFavoriteButton
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        return verticalStackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }()
    
    private lazy var creationDateLabel: UILabel = {
        var creationDateLabel = UILabel()
        creationDateLabel.numberOfLines = 0
        return creationDateLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
        self.setupStackView()
        self.setupAddToFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.descriptionLabel.text = nil
        self.creationDateLabel.text = nil
        self.addToFavoriteButton.isSelected = false
    }

    private func setupImageView() {
        self.contentView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6),
            self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    private func setupStackView() {
        [self.descriptionLabel, 
         self.creationDateLabel].forEach { self.verticalStackView.addArrangedSubview($0) }
        self.contentView.addSubview(self.verticalStackView)
        
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 15),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupAddToFavoriteButton() {
        self.contentView.addSubview(self.addToFavoriteButton)
        
        NSLayoutConstraint.activate([
            self.addToFavoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor),
            self.addToFavoriteButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor)
        ])
    }

    @objc 
    func tapFavouriteButton() {
        self.cellViewModel?.toogleFavourite()
        self.addToFavoriteButton.isSelected.toggle()
    }

    func configureCell(with viewModel: DetailCellViewModel) {
        self.imageView.sd_setImage(with: viewModel.image)
        self.descriptionLabel.text = viewModel.description
        self.creationDateLabel.text = viewModel.createdDate
        self.addToFavoriteButton.isSelected = viewModel.isFavourite ?? false
        self.cellViewModel = viewModel
    }

    func returnImageViewFrame() -> CGRect {
        self.imageView.frame
    }
}
