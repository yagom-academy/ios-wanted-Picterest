//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private let labelStackView = LabelStackView()
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    func fetchData(_ photo: Photo, _ indexPath: IndexPath) {
        layout()
        
        labelStackView.photoLabel.text = "\(indexPath.row)번째 사진"
        
        LoadImage().loadImage(photo.urls.small) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ImageCollectionViewCell {
    
    func layout() {
        [
            photoImageView, labelStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
