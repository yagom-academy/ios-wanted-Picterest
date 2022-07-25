//
//  Icon.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

enum Icon: String {
    case photo = "photo"
    case photoFill = "photo.fill"
    case starBubble = "star.bubble"
    case starBubbleFill = "star.bubble.fill"
    
    var image: UIImage? { UIImage(systemName: self.rawValue) }
}
