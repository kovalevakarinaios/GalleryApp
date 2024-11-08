//
//  FavouritePhoto+CoreDataProperties.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//
//

import Foundation
import CoreData
import UIKit

extension FavouritePhoto {

    @nonobjc 
    public class func fetchRequest() -> NSFetchRequest<FavouritePhoto> {
        return NSFetchRequest<FavouritePhoto>(entityName: "FavouritePhoto")
    }

    @NSManaged public var id: String?
    @NSManaged public var likes: Int16
    @NSManaged public var createdAt: String?
    @NSManaged public var generalDescription: String?
    @NSManaged public var height: Int16
    @NSManaged public var width: Int16
    @NSManaged public var regularData: Data?
    @NSManaged public var thumbData: Data?
}

extension FavouritePhoto: Identifiable {

}

extension FavouritePhoto {
    var unwrappedId: String {
        return id ?? UUID().uuidString
    }
    
    var unwrappedRegularPhoto: Data {
        return regularData ?? UIImage(systemName: "trash.slash")?.pngData() ?? Data()
    }
    
    var unwrappedThumbPhoto: Data {
        return thumbData ?? UIImage(systemName: "trash.slash")?.pngData() ?? Data()
    }
    
    var unwrappedCreatedAt: String {
        return createdAt ?? "Unknown Date"
    }
    
    var unwrappedGeneralDescription: String {
        return generalDescription ?? "No Description"
    }
}
