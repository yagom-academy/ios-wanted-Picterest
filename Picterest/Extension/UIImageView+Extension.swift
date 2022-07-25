//
//  UIImageView+Extension.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

extension UIImageView {
    func load(_ url: String) {
        NetworkManager.fetchImage(urlString: url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
