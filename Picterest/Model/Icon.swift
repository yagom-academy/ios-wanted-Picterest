//
//  Icon.swift
//  Picterest
//
//

import Foundation
import UIKit

enum Icon {
    case star
    case starFill
    
    var image: UIImage? {
        switch self {
        case .star:
            return UIImage(systemName: "star")
        case .starFill:
            return UIImage(systemName: "star.fill")
        }
    }
}
