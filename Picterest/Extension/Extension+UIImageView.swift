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
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }
        CacheManager.shared.urlCache.getCachedResponse(for: dataTask) { response in
            guard let response = response else {
                dataTask.resume()
                return
            }
            self.image = UIImage(data: response.data)
        }
        }
}
