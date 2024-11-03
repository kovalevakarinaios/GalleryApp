//
//  Photo.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 3.11.24.
//

import Foundation

struct PhotoModel {
    let id: String
    let createdAt: String
    let generalDescription: String
    let urls: PhotoURLs
    var isFavorite: Bool
    let width: Int
    let height: Int
}
