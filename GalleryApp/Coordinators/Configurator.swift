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

final class Configurator: ConfiguratorProtocol {
    
    static func createMainModule() -> UIViewController {
        let networkManager = NetworkManager()
        let viewModel = MainViewModel(networkManager: networkManager)
        let viewController = MainViewController(viewModel: viewModel)
        return viewController
    }
}
