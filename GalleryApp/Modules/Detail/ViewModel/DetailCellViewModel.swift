//
//  DetailCellViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation
import SDWebImage

class DetailCellViewModel: BaseCellViewModel {
    
    var photoItem: PhotoItem
    var id: String
    var image: URL?
    var isFavourite: Bool?
    var description: String
    var createdDate: String
    var aspectRatio: CGFloat
    var regularImageData: Data?
    var imageSource: ImageSource

    init(item: PhotoItem) {
        self.photoItem = item
        self.id = item.id
        self.createdDate = item.createdAt
        self.description = item.generalDescription
        self.imageSource = item.imageSource
        self.regularImageData = item.regularPhoto
        self.aspectRatio = CGFloat(item.height) / CGFloat(item.width)
        super.init()
        self.image = self.makeImageURL(stringURL: item.urls?.regular)
        self.isFavourite = self.checkFavoriteStatus(id: self.id)
    }
    
    func toogleFavourite() {
        isFavourite?.toggle()
        CoreDataHelper.toogleFavorite(photoItem: photoItem)
    }
}
