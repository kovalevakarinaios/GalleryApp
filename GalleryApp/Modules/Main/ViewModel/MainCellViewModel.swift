//
//  MainViewModelCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 4.11.24.
//

import Foundation
import UIKit

class MainCellViewModel {
    
    var id: String
    var image: URL?
    var data: Data?
    var isFavourite: Bool?
    var imageSource: ImageSource

    init(item: PhotoItem) {
        self.id = item.id
        self.data = item.thumbPhoto
        self.imageSource = item.imageSource
        self.image = self.makeImageURL(stringURL: item.urls?.thumb)
        self.isFavourite = self.checkFavoriteStatus(id: self.id)
    }

    private func makeImageURL(stringURL: String?) -> URL? {
        guard let stringURL = stringURL else { return nil }
        return URL(string: stringURL)
    }
    
    func checkFavoriteStatus(id: String) -> Bool {
        print("MainCellViewModel: checkFavouritestatus")
        return CoreDataHelper.isFavourite(id: id)
    }
}
