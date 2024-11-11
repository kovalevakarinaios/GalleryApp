//
//  GalleryLayout.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 29.10.24.
//

import Foundation
import UIKit

protocol GalleryLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

// MARK: Custom UICollectionViewLayout
final class GalleryLayout: UICollectionViewLayout {
    
    private let cellPadding: CGFloat = 6
    
    // Reference to delegate
    weak var delegate: GalleryLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // Store content ContentSize (Height + Width)
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    // Minimum column width
    private var minColumnWidth: CGFloat = 150
    
    // Calculation of the number of columns based on the collectionview's width and the minimum column width
    private var numberOfColumns: Int {
        let maxColumns = Int(contentWidth / minColumnWidth)
        // The minimum number of columns is 2, the maximum is 4
        return max(2, min(maxColumns, 4))
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }

        self.contentHeight = 0
        
        let columnWidth = self.contentWidth / CGFloat(self.numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for column in 0..<self.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: self.numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            // Get photo aspect ratio
            let aspectRatio = self.delegate?.collectionView(collectionView, ratioForPhotoAtIndexPath: indexPath) ?? 1
            let photoHeight = columnWidth * aspectRatio
            // Add space for padding to height of photo
            let itemHeight = self.cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: itemHeight)
            // Add padding inside cell frame on all sides
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)
            
            // Cache attributes for later use
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)
            
            // Update total content height by bottom edge of frame
            self.contentHeight = max(self.contentHeight, frame.maxY)
            yOffset[column] += itemHeight
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }

    // Add cached layout attributes for the item at specified indexpath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        self.cache[indexPath.item]
    }
    
    func removeCache() {
        self.cache.removeAll()
    }
}
