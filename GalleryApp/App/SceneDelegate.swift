//
//  SceneDelegate.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 26.10.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: Configurator.createMainModule())
        window.makeKeyAndVisible()
        self.window = window
    }
}
