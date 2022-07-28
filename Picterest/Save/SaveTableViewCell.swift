//
//  SaveTableViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/27.
//

import UIKit

class SaveTableViewCell: UITableViewCell {
    static let identifier = "SaveTableViewCell"
    
    let labelStackView = LabelStackView()
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    func fetchData(_ photo: SavePhoto) {
        layout()
        loadImage(photo)
    }
}

extension SaveTableViewCell {
    
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
    
    private func loadImage(_ photo: SavePhoto) {
        LoadImage().loadImage(photo.originUrl!) { result in
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
