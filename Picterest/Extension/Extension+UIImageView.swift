//
//  Extension+UIImageView.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: String) {
        NetworkManager.shared.fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        }
}
