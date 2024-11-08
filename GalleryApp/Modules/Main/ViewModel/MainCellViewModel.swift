//
//  MainViewModelCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 4.11.24.
//

import Foundation
import UIKit

class MainCellViewModel: BaseCellViewModel {
    
    var id: String
    var image: URL?
    var data: Data?
    var isFavourite: Bool?
    var imageSource: ImageSource

    init(item: PhotoItem) {
        self.id = item.id
        self.data = item.thumbPhoto
        self.imageSource = item.imageSource
        super.init()
        self.image = self.makeImageURL(stringURL: item.urls?.thumb)
        self.isFavourite = self.checkFavoriteStatus(id: self.id)
    }
}
