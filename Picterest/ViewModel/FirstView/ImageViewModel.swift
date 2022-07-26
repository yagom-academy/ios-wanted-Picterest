//
//  ImageViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation
import UIKit

struct ImageViewModel {
    private let image: ImageModel
    
    init(image : ImageModel){
        self.image = image
    }
    
    var id: String {
        return image.id
    }
    
    var url: String {
        return image.urls.small
    }
    
    var width: Double {
        return image.width
    }
    
    var height: Double {
        return image.height
    }
    
}
