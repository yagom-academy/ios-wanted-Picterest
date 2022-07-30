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
        NetworkManager.fetchImage(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    /// 스토리지에서 받아오기
    func load(starImage: StarImage) {
        StorageManager.getImage(starImage: starImage) { [weak self] image in
            self?.image = image
        }
    }
}
