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
    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: rawValue,
            image: image,
            selectedImage: selectedImage
        )
    }
}
