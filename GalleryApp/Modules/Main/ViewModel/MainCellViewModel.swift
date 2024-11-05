//
//  MainViewModelCell.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 4.11.24.
//

import Foundation
import UIKit

class MainCellViewModel {
    
    private var id: String
    var image: URL?
//    var isFavourite: Bool?

    init(item: PhotoItem) {
        self.id = item.id
        self.image = self.makeImageURL(stringURL: item.urls.thumb)
    }
    
    private func makeImageURL(stringURL: String) -> URL? {
        URL(string: stringURL)
    }
    
    private func checkFavoriteStatus(id: String) -> Bool {
        // Сходи в кордату, узнай тру или фолс и присвой переменной это значение
        false
    }
}
