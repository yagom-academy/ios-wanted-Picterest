//
//  MainTabBarController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private enum Value {
        static let backgroundColor:UIColor = .init(red: 110/256, green: 77/256, blue: 65/256, alpha: 1)
        static let tintColor:UIColor = .white
        static let firtSlotImageSystemName = "photo.fill.on.rectangle.fill"
        static let secondSlotImageSystemName = "star.bubble"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = Value.backgroundColor
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBar.tintColor = Value.tintColor
    }
    
    private func setVC() {
        let imageListViewController = ImageListViewController()
        imageListViewController.tabBarItem.image = UIImage(systemName: Value.firtSlotImageSystemName)

        let savedImageListViewController = SavedImageListViewController()
        savedImageListViewController.tabBarItem.image = UIImage(systemName: Value.secondSlotImageSystemName)

        self.viewControllers = [imageListViewController, savedImageListViewController]
    }

}
