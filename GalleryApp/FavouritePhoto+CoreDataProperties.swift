//
//  FavouritePhoto+CoreDataProperties.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//
//

import Foundation
import CoreData


extension FavouritePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritePhoto> {
        return NSFetchRequest<FavouritePhoto>(entityName: "FavouritePhoto")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: Data?

}

extension FavouritePhoto : Identifiable {

}
