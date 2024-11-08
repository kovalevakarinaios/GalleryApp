//
//  Configurator.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 8.11.24.
//

import UIKit

protocol ConfiguratorProtocol {
    static func createMainModule() -> UIViewController
}

class Configurator: ConfiguratorProtocol {
    
    static func createMainModule() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        return viewController
    }
}
