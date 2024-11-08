//
//  Photo.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import Foundation

enum ImageSource {
    case localData
    case url
    case placeholder
}

struct PhotoItem: Codable, Hashable {
    let id: String
    let likes: Int
    let width: Int
    let height: Int
    let createdAt: String
    let generalDescription: String
    // Image from Internet
    let urls: PhotoURLs?
    // Image from CoreData
    var regularPhoto: Data?
    var thumbPhoto: Data?
    
    var imageSource: ImageSource {
        if regularPhoto != nil, thumbPhoto != nil {
            return .localData
        } else if urls?.regular != nil, urls?.thumb != nil {
            return .url
        } else {
            return .placeholder
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, likes, urls, height, width, regularPhoto,thumbPhoto
        case createdAt = "created_at"
        case generalDescription = "alt_description"
    }
    
    init(coreDataItem: FavouritePhoto) {
        self.id = coreDataItem.unwrappedId
        self.likes = Int(coreDataItem.likes)
        self.width = Int(coreDataItem.width)
        self.height = Int(coreDataItem.height)
        
        self.createdAt = coreDataItem.unwrappedCreatedAt
        self.generalDescription = coreDataItem.unwrappedGeneralDescription
        self.regularPhoto = coreDataItem.unwrappedRegularPhoto
        self.thumbPhoto = coreDataItem.unwrappedThumbPhoto
        self.urls = nil
    }
}

struct PhotoURLs: Codable, Hashable {
    let regular: String
    let thumb: String
}
