//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .cyan
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.contentView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
    }
    
    func configureCell(image: UIImage) {
        self.imageView.image = image
    }
}
