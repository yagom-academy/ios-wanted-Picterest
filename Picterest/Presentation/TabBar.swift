//
//  TabBar.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

enum TabBar: String, CaseIterable {
    case photoList = "Images"
    case savedList = "Saved"
    
    private var image: UIImage? {
        switch self {
        case .photoList: return Icon.photo.image
        case .savedList: return Icon.starBubble.image
        }
    }
    private var selectedImage: UIImage? {
        switch self {
        case .photoList: return Icon.photoFill.image
        case .savedList: return Icon.starBubbleFill.image
        }
    }
    
    private var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: rawValue,
            image: image,
            selectedImage: selectedImage
        )
    }
    
    var viewController: UIViewController {
        switch self {
        case .photoList:
            let vc = PhotoListViewController()
            vc.tabBarItem = self.tabBarItem
            return vc
        case .savedList:
            let vc = SavedListViewController()
            vc.tabBarItem = self.tabBarItem
            return vc
        }
    }
}
