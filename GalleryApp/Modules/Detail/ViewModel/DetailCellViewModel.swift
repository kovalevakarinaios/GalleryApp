//
//  DetailCellViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation
import SDWebImage

class DetailCellViewModel {
    
    var id: String
    var image: URL?
    var isFavourite: Bool?
    var description: String
    var createdDate: String
    var width: Int
    var height: Int

    init(item: PhotoItem) {
        self.id = item.id
        self.createdDate = item.createdAt
        self.description = item.generalDescription
        self.width = item.width
        self.height = item.height
        self.image = self.makeImageURL(stringURL: item.urls.regular)
        self.isFavourite = self.checkFavoriteStatus(id: self.id)
    }
    
    private func makeImageURL(stringURL: String) -> URL? {
        URL(string: stringURL)
    }
    
    private func checkFavoriteStatus(id: String) -> Bool {
        print("DetailCellViewModel: checkFavouritestatus")
        return CoreDataHelper.isFavourite(id: id)
    }
    
    func toogleFavourite() {
        isFavourite?.toggle()
        CoreDataHelper.toogleFavorite(id: id, image: image)
    }
}
