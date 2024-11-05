//
//  CoreDataHelper.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 5.11.24.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func createEntity(id: String, image: Data, handler: @escaping (_ results: Bool?) -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            handler(false)
            return
        }
        
        let fetchPhoto: NSFetchRequest<Photo>
    }
    
}
