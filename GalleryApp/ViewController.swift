//
//  ViewController.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 26.10.24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        NetworkManager.shared.getPhotos { result in
            switch result {
            case .success(let success):
                print("success \(success)")
                
            case .failure(let failure):
                print("f \(failure)")
                
            }
        }
    }
}
