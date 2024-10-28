//
//  Photo.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import Foundation

struct Photo: Codable {
    let id: String
    let likes: Int
    let createdAt: String
    let userDescription: String?
    let generalDescription: String
    let urls: PhotoURLs
    
    enum CodingKeys: String, CodingKey {
        case id, likes, urls
        case createdAt = "created_at"
        case userDescription = "description"
        case generalDescription = "alt_description"
    }
}

struct PhotoURLs: Codable {
    let regular: String
    let thumb: String
}
