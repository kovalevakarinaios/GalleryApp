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
    private static func createEntity(id: String, image: Data) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let newPhoto = FavouritePhoto(context: context)
        newPhoto.id = id
        newPhoto.image = image
        do {
            try context.save()
            print("Item saved, id: \(id)")
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
    
    static func toogleFavorite(id: String, image: URL?) {
        if self.isFavourite(id: id) {
            self.deleteEntity(id: id)
        } else {
            SDWebImageManager.shared.loadImage(with: image,
                                               options: .highPriority,
                                               progress: nil
            ) { image, data, error, _, _, _ in
                if let error = error {
                    print("Failed to load image data with SDWebImage: \(error)")
                } else {
                    guard let pngImage = image?.pngData() else { return }
                    self.createEntity(id: id, image: pngImage)
                }
            }
        }
    }
}
