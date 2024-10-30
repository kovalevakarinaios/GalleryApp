//
//  Photo.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 27.10.24.
//

import Foundation

struct Photo: Codable, Hashable {
    let id: String
    let likes: Int
    let width: Int
    let height: Int
    let createdAt: String
    let userDescription: String?
    let generalDescription: String
    let urls: PhotoURLs
    
    enum CodingKeys: String, CodingKey {
        case id, likes, urls, height, width
        case createdAt = "created_at"
        case userDescription = "description"
        case generalDescription = "alt_description"
    }
}

struct PhotoURLs: Codable, Hashable {
    let regular: String
    let thumb: String
}
