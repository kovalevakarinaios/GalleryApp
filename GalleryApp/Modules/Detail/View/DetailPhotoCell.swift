//
//  DetailPhotoCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 3.11.24.
//

import Foundation
import UIKit

final class DetailPhotoCell: UICollectionViewCell {
    
    static let identifier = "DetailPhotoCell"

    private var imageHeightConstraint: NSLayoutConstraint!
    
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
    
    private lazy var imageView = UIImageView()
    
    private lazy var verticalStackView: UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        return verticalStackView
    }()
    
    private lazy var descriptionLabel = UILabel()
    
    private lazy var creationDateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
        self.setupStackViewAndLabels()
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
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)

        NSLayoutConstraint.activate([
            self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupStackViewAndLabels() {
        [self.descriptionLabel,
         self.creationDateLabel].forEach { $0.numberOfLines = 0 }
        
        [self.descriptionLabel,
         self.creationDateLabel].forEach { self.verticalStackView.addArrangedSubview($0) }
        self.contentView.addSubview(self.verticalStackView)
        
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 15),
            self.verticalStackView.widthAnchor.constraint(equalTo: self.imageView.widthAnchor),
            self.verticalStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    private func setupAddToFavoriteButton() {
        self.contentView.addSubview(self.addToFavoriteButton)
        
        NSLayoutConstraint.activate([
            self.addToFavoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -10),
            self.addToFavoriteButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -10)
        ])
    }
    
    private func updateImageConstraints(withAspectRatio aspectRatio: CGFloat) {
        if let heightConstraint = imageHeightConstraint {
            NSLayoutConstraint.deactivate([heightConstraint])
        }

        imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor,
                                                                  multiplier: aspectRatio)
        
        NSLayoutConstraint.activate([imageHeightConstraint])
    }

    @objc 
    func tapFavouriteButton() {
        self.cellViewModel?.toogleFavourite()
        self.addToFavoriteButton.isSelected.toggle()
    }

    func configureCell(with viewModel: DetailCellViewModel) {
        self.cellViewModel = viewModel
        switch viewModel.imageSource {
        case .localData:
            guard let data = viewModel.regularImageData else { return }
            self.imageView.image = UIImage(data: data)
        case .url:
            self.imageView.sd_setImage(with: viewModel.image)
        case .placeholder:
            self.imageView.image = UIImage(systemName: "square.and.arrow.down")
        }
        self.descriptionLabel.text = viewModel.description
        self.creationDateLabel.text = "Created " + viewModel.createdDate
        self.addToFavoriteButton.isSelected = viewModel.isFavourite ?? false  
        self.updateImageConstraints(withAspectRatio: viewModel.aspectRatio)
    }

    func returnImageViewFrame() -> CGRect {
        self.imageView.frame
    }
}
