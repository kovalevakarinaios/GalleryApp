//
//  CoreDataHelper.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation
import CoreData
import SDWebImage
import UIKit

class CoreDataHelper {

    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // Add one entity to database
    private static func createEntity(photoItem: PhotoItem) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let newPhoto = FavouritePhoto(context: context)
        newPhoto.id = photoItem.id
        newPhoto.createdAt = photoItem.createdAt
        newPhoto.generalDescription = photoItem.generalDescription
        newPhoto.height = Int16(photoItem.height)
        newPhoto.likes = Int16(photoItem.likes)
        newPhoto.regularData = photoItem.regularPhoto
        newPhoto.thumbData = photoItem.thumbPhoto
        newPhoto.width = Int16(photoItem.width)
        do {
            try context.save()
            print("Item saved, id: \(photoItem.id)")
        } catch {
            print("Error-saving data")
        }
    }
    
    // Delete one entity from database
    private static func deleteEntity(id: String) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
                print("Item deleted, id: \(id)")
            }
            try context.save()
        } catch {
            print("Failed to delete photo")
        }
    }
    
    // Fetch all entities from database
    static func fetchData(onSuccess: @escaping ([FavouritePhoto]?) -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        do {
            let items = try context.fetch(FavouritePhoto.fetchRequest()) as? [FavouritePhoto]
            onSuccess(items)
        } catch {
            print("Error-fetching photo")
        }
    }
    
    // Check photo's favourite status
    static func isFavourite(id: String) -> Bool {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        print("CoreData - Check favourite status")
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                print("Photo ID: \(id) is favourite")
            } else {
                print("Photo ID: \(id) isn't favourite")
            }
            return count > 0
        } catch {
            print("Failed to detect favourite photo")
            return false
        }
    }
    
    static func toogleFavorite(photoItem: PhotoItem) {
        var photoItem = photoItem
        if self.isFavourite(id: photoItem.id) {
            self.deleteEntity(id: photoItem.id)
        } else {
            switch photoItem.imageSource {
            case .localData:
                self.createEntity(photoItem: photoItem)
            case .url:
                guard let regularURL = photoItem.urls?.regular else { return }
                guard let thumbURL = photoItem.urls?.thumb else { return }
                SDWebImageManager.shared.loadImage(with: URL(string: regularURL),
                                                   options: .highPriority,
                                                   progress: nil
                ) { image, _, error, _, _, _ in
                    if let error = error {
                        print("Failed to load image data with SDWebImage: \(error)")
                    } else {
                        guard let pngImage = image?.pngData() else { return }
                        photoItem.regularPhoto = pngImage
                    }
                }
                SDWebImageManager.shared.loadImage(with: URL(string: thumbURL),
                                                   options: .highPriority,
                                                   progress: nil
                ) { image, _, error, _, _, _ in
                    if let error = error {
                        print("Failed to load image data with SDWebImage: \(error)")
                    } else {
                        guard let pngImage = image?.pngData() else { return }
                        photoItem.thumbPhoto = pngImage
                      
                    }
                }
                self.createEntity(photoItem: photoItem)
            case .placeholder:
                print("CoreData placeholder")
            }
           
        }
    }
}
