//
//  SceneDelegate.swift
//  Picterest
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow.init(windowScene: windowScene)
        let tabbarView = TabbarView()
        
        window?.rootViewController = UIHostingController.init(rootView: tabbarView)
        window?.makeKeyAndVisible()
    }
    
}

