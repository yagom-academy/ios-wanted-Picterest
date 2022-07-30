//
//  imageCollectionViewCell.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "imageCollectionViewCell"
    
    var isSaved: Bool = false
    var starButtonStatusChanged: () -> Void = {}
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var descriptionView: UIView = {
        let descriptionView = UIView()
        descriptionView.backgroundColor = .gray
        descriptionView.alpha = 0.5
        descriptionView.layer.cornerRadius = 10
        descriptionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return descriptionView
    }()
    
    lazy var starButton: UIButton = {
        let starButton = UIButton()
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .white
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        return starButton
    }()
    
    private lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.font = .systemFont(ofSize: 15)
        indexLabel.textColor = .white
        indexLabel.textAlignment = .right
        return indexLabel
    }()
    
    @objc func starButtonTapped() {
        starButtonStatusChanged()
    }

    func configureImageCollectionCell(with image: ImageData, at index: Int) {
        setSubView()
        setConstraints()
        self.imageView.loadImage(url: image.image.urls.small)
        self.indexLabel.text = "\(index)번째 사진"
        setStarButton(isSaved: LocalFileManager.shared.checkFileExistInLocal(id: image.image.id))
    }
    
    func configureSavedCollectionCell(with image: ImageData) {
        setSubView()
        setConstraints()
        self.imageView.loadFromLocal(id: image.image.id)
        self.indexLabel.text = image.memo
        setStarButton(isSaved: true)
    }
    
    func setStarButton(isSaved: Bool) {
        if isSaved {
            self.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.starButton.tintColor = .systemYellow
        } else {
            self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.starButton.tintColor = .white
        }
    }
    
    private func setSubView() {
        [imageView, descriptionView, starButton, indexLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        setConstraintOfImaveView()
        setConstraintOfDescriptionView()
        setConstraintOfStarButton()
        setConstraintOfIndexLabel()
    }
    
    private func setConstraintOfImaveView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setConstraintOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionView.heightAnchor.constraint(equalToConstant: 30),
            descriptionView.topAnchor.constraint(equalTo: self.topAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setConstraintOfStarButton() {
        NSLayoutConstraint.activate([
            starButton.widthAnchor.constraint(equalToConstant: 20),
            starButton.heightAnchor.constraint(equalToConstant: 20),
            starButton.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor),
            starButton.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 10)
        ])
    }
    
    private func setConstraintOfIndexLabel() {
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor, constant: 10),
            indexLabel.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor),
            indexLabel.heightAnchor.constraint(equalToConstant: 30),
            indexLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -10)
        ])
    }
}

