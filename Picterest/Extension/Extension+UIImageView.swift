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
        guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
}
