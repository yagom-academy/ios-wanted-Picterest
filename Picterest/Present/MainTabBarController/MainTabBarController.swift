//
//  MainTabBarController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Define {
        static let firtSlotImageSystemName = "photo.fill.on.rectangle.fill"
        static let secondSlotImageSystemName = "star.bubble"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = Style.Color.brown
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBar.tintColor = Style.Color.tint
    }
    
    private func setVC() {
        let imageListViewController = ImageListViewController()
        imageListViewController.tabBarItem.image = UIImage(systemName: Define.firtSlotImageSystemName)

        let savedImageListViewController = SavedImageListViewController()
        savedImageListViewController.tabBarItem.image = UIImage(systemName: Define.secondSlotImageSystemName)

        self.viewControllers = [imageListViewController, savedImageListViewController]
    }
}
