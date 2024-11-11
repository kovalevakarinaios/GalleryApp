//
//  PlaceholderCollectionViewCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 8.11.24.
//

import Foundation
import UIKit

// swiftlint:disable:next line_length
// Placeholder is needed to insert it into cells that cannot be processed (for example, if we lost internet in process of fast scrolling)
final class PlaceholderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaceholderCollectionViewCell"
    
    private lazy var placeHolderLabel: UILabel = {
        var placeHolderLabel = UILabel()
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.text = "Photo is loading..."
        placeHolderLabel.textAlignment = .center
        return placeHolderLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupPlaceHolderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlaceHolderLabel() {
        self.contentView.addSubview(self.placeHolderLabel)
        
        NSLayoutConstraint.activate([
            self.placeHolderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.placeHolderLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.placeHolderLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}
