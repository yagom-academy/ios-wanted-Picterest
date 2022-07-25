//
//  TabBarViewController.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let imageVC = ImageViewController()
    let saveVC = SaveViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        let navigationImage = UINavigationController(rootViewController: imageVC)
        let navigationSave = UINavigationController(rootViewController: saveVC)
        
        navigationImage.navigationBar.prefersLargeTitles = true
        navigationSave.navigationBar.prefersLargeTitles = true
        
        imageVC.title = "Images"
        saveVC.title = "Saved"
        
        imageVC.tabBarItem.image = UIImage.init(systemName: "photo.fill.on.rectangle.fill")
        saveVC.tabBarItem.image = UIImage.init(systemName: "star.bubble")
        
        setViewControllers([navigationImage, navigationSave], animated: false)
    }
}

