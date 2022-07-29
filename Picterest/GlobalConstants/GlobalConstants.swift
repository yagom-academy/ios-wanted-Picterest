//
//  GlobalConstants.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/29.
//

import Foundation
import UIKit

enum GlobalConstants {
    
    enum Name {
        enum ViewController {
            static var imageListVC: String = "Picterest"
            static var imageRepositoryVC: String = "Repository"
        }
        enum CoreData {
            static var modelName = "PictureModel"
        }
        enum TabbarItem {
            static var imageListVC: String = "Images"
            static var repositoryVC: String = "Saved"
        }
    }
    
    enum Image {
        enum Tabbar {
            case photo
            case star
            
            var image: UIImage {
                switch self {
                case .photo:
                    return UIImage(systemName: "photo.fill.on.rectangle.fill") ?? UIImage()
                case .star:
                    return UIImage(systemName: "star.bubble") ?? UIImage()
                }
            }
        }
        enum PictureCell {
            case saved
            case nomal
            case photo
            
            var image: UIImage {
                switch self {
                case .saved:
                    return UIImage(systemName: "star.fill") ?? UIImage()
                case .nomal:
                    return UIImage(systemName: "star") ?? UIImage()
                case .photo:
                    return UIImage(systemName: "photo") ?? UIImage()
                }
            }
        }
    }
    
}
