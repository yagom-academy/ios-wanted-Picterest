//
//  SavedImageViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/27.
//

import Foundation

class SavedImageViewModel {
    
    private let image: ImageModel
    
    init(image : ImageModel, memo: String){
        self.image = image
        self.memo = memo
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
    
    var memo: String 
    
}
