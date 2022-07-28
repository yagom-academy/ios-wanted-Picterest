//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

protocol SavePhotoImageDelegate: AnyObject {
    func tapStarButton(sender: UIButton, indexPath: IndexPath)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    weak var delegate: SavePhotoImageDelegate?
    
    private var currentIndexPath: IndexPath?
    
    let labelStackView = LabelStackView()
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    func fetchData(_ photo: Photo, _ indexPath: IndexPath, _ isStarButtonSelected: Bool) {
        layout()
        loadImage(photo)
        addTargetStarButton()
        
        currentIndexPath = indexPath
        labelStackView.starButton.isSelected = isStarButtonSelected
        labelStackView.photoLabel.text = "\(indexPath.row)번째 사진"
    }
}

extension ImageCollectionViewCell {
    
    override func prepareForReuse() {
        photoImageView.image = nil
        labelStackView.starButton.isSelected = false
    }
    
    private func layout() {
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
    
    private func loadImage(_ photo: Photo) {
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
    
    private func addTargetStarButton() {
        labelStackView.starButton.addTarget(self, action: #selector(tapStarButton), for: .touchUpInside)
    }

    @objc func tapStarButton() {
        guard let currentIndexPath = currentIndexPath else { return }
        labelStackView.starButton.isSelected = !labelStackView.starButton.isSelected
        delegate?.tapStarButton(sender: labelStackView.starButton, indexPath: currentIndexPath)
    }
}
