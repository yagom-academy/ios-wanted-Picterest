//
//  SceneDelegate.swift
//  Picterest
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow.init(windowScene: windowScene)
        let tabbarController = UITabBarController()
        
        let vc = ViewController()
        vc.tabBarItem = .init(title: "first", image: UIImage.init(systemName: "circle"), tag: 2)
        let vc2 = SecondViewController()
        vc2.tabBarItem = .init(title: "second", image: UIImage.init(systemName: "square"), tag: 1)
        tabbarController.viewControllers = [vc,vc2]
        tabbarController.tabBar.backgroundColor = .white
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
    }
    
}

