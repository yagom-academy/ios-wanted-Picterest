//
//  Picterest++UIImageView.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let fetchedData = data, let image = UIImage(data: fetchedData), error == nil else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
            print("from download")
        }.resume()
    }
}
