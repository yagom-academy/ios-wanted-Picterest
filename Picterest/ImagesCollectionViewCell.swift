//
//  ImagesCollectionViewCell.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configureCell(_ photo: PhotoModel) {
        imageView.loadImage(photo.urls.raw)
    }
}
