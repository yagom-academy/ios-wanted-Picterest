//
//  UIImageView+Extension.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

extension UIImageView {
    /// network에서 받아오기
    func load(url: String) {
        NetworkManager.fetchImage(urlString: url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    /// 스토리지에서 받아오기
    func load(id: String) {
        self.image = StorageManager.getImage(id: id)
    }
}
