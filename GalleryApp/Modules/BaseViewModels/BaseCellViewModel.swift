//
//  BaseCellViewModel.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 7.11.24.
//

import Foundation

class BaseCellViewModel {

    func makeImageURL(stringURL: String?) -> URL? {
        guard let stringURL = stringURL else { return nil }
        return URL(string: stringURL)
    }
    
    func checkFavoriteStatus(id: String) -> Bool {
        return CoreDataHelper.isFavourite(id: id)
    }
}
