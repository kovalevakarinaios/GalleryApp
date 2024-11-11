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

final class CoreDataHelper {

    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouritePhotoModel")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }

        return container
    }()

    // Add one entity to database
    private static func createEntity(photoItem: PhotoItem) {
        let context = persistentContainer.viewContext
        
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
        } catch {
            debugPrint("Error-saving data")
        }
    }
    
    // Delete one entity from database
    private static func deleteEntity(id: String) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            try context.save()
        } catch {
            debugPrint("Failed to delete photo")
        }
    }
    
    // Fetch all entities from database
    static func fetchData(onSuccess: @escaping ([FavouritePhoto]?) -> Void) {
        let context = persistentContainer.viewContext
        
        do {
            let items = try context.fetch(FavouritePhoto.fetchRequest()) as? [FavouritePhoto]
            onSuccess(items)
        } catch {
            debugPrint("Error-fetching photo")
        }
    }
    
    // Check photo's favourite status
    static func isFavourite(id: String) -> Bool {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavouritePhoto> = FavouritePhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            debugPrint("Failed to detect favourite photo")
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
                        debugPrint("Failed to load image data with SDWebImage: \(error)")
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
                        debugPrint("Failed to load image data with SDWebImage: \(error)")
                    } else {
                        guard let pngImage = image?.pngData() else { return }
                        photoItem.thumbPhoto = pngImage
                      
                    }
                }
                self.createEntity(photoItem: photoItem)
            case .placeholder:
                break
            }
           
        }
    }
}
