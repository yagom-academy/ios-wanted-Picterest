//
//  CoredataManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation
import UIKit

class CoredataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImageInfo(_ imageViewModel: ImageViewModel, memo: String, saveLocation: String){
        let newImageInfo = ImageInfo(context: context)
        newImageInfo.id = imageViewModel.id
        newImageInfo.memo = memo
        newImageInfo.originURL = URL(string: imageViewModel.url) 
        newImageInfo.saveLocation = saveLocation
    }
    
}
