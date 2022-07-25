//
//  SceneDelegate.swift
//  Picterest
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScence = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScence)
        
        let tab = UITabBarController()
        let ImagesView = ImagesViewController()
        let SavedView = SavedViewController()
            
        ImagesView.tabBarItem = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), selectedImage: nil)
        SavedView.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "star.bubble.fill"), selectedImage: nil)
        
        tab.view.backgroundColor = .white
        tab.setViewControllers([ImagesView, SavedView], animated: false)
        
        window?.rootViewController = tab
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

