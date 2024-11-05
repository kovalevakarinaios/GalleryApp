//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import UIKit
import SDWebImage

class MainPhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favouriteStatusImageView: UIImageView = {
        var favouriteStatusImageView = UIImageView()
        favouriteStatusImageView.translatesAutoresizingMaskIntoConstraints = false
        favouriteStatusImageView.tintColor = .red
        return favouriteStatusImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.favouriteStatusImageView.image = nil
    }
    
    private func setupImageView() {
        self.contentView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
    private func setupFavouriteImageView() {
        self.contentView.addSubview(self.favouriteStatusImageView)
        self.favouriteStatusImageView.image = UIImage(systemName: "heart.fill")
        
        NSLayoutConstraint.activate([
            self.favouriteStatusImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.favouriteStatusImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.favouriteStatusImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor,
                                                                 multiplier: 0.2),
            self.favouriteStatusImageView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 15),
            self.favouriteStatusImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor,
                                                                  multiplier: 0.2),
            self.favouriteStatusImageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 15)
        ])
    }
    
    func configureCell(with viewModel: MainCellViewModel) {
        let viewModel = viewModel
        self.imageView.sd_setImage(with: viewModel.image)
        viewModel.checkFavoriteStatus(id: viewModel.id) ? self.setupFavouriteImageView() : nil
    }
}
