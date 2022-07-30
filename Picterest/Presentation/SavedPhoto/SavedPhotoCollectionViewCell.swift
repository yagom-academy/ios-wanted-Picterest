//
//  SavedPhotoCollectionViewCell.swift
//  Picterest
//
//  Created by BH on 2022/07/29.
//

import CoreData
import UIKit

class SavedPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "SavedPhotoCollectionViewCell"
    
    // MARK: - UIProperties
    
    private lazy var savedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.alpha = Style.alpha
        view.backgroundColor = .black
        view.layer.cornerRadius = Style.cornerRadius
        return view
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(Style.selectedStarImage, for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "0번째 사진"
        label.textColor = .white
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
}

// MARK: - Layout Extension

extension SavedPhotoCollectionViewCell {
    
    func setupCell(photo: NSManagedObject) {
        guard let imageID = photo.value(forKey: "id") as? String,
              let imageMemo = photo.value(forKey: "memo") as? String else { return }
        let savedImage = ImageManager.shared.loadImage(id: imageID)
        
        DispatchQueue.main.async {
            self.savedImageView.image = savedImage
            self.memoLabel.text = imageMemo
        }
    }
    
    private func setupView() {
        [savedImageView,
         topView,
         starButton,
         memoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfImageView()
        setupConstraintsOfTopView()
        setupConstraintsOfStarButton()
        setupConstraintsOfMemoLabel()
    }
    
    private func setupConstraintsOfImageView() {
        NSLayoutConstraint.activate([
            savedImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            savedImageView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor
            ),
            savedImageView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor
            ),
            savedImageView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    private func setupConstraintsOfTopView() {
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(
                equalTo: savedImageView.safeAreaLayoutGuide.leadingAnchor
            ),
            topView.topAnchor.constraint(
                equalTo: savedImageView.safeAreaLayoutGuide.topAnchor
            ),
            topView.trailingAnchor.constraint(
                equalTo: savedImageView.safeAreaLayoutGuide.trailingAnchor
            ),
            topView.heightAnchor.constraint(equalToConstant: Style.alphaViewHeight)
        ])
    }
    
    private func setupConstraintsOfStarButton() {
        NSLayoutConstraint.activate([
            starButton.centerYAnchor.constraint(
                equalTo: topView.centerYAnchor
            ),
            starButton.leadingAnchor.constraint(
                equalTo: topView.leadingAnchor,
                constant: Style.leadingPadding
            )
        ])
    }
    
    private func setupConstraintsOfMemoLabel() {
        NSLayoutConstraint.activate([
            memoLabel.centerYAnchor.constraint(
                equalTo: topView.centerYAnchor
            ),
            memoLabel.trailingAnchor.constraint(
                equalTo: topView.trailingAnchor,
                constant: Style.trailingPadding
            )
        ])
    }
    
}

// MARK: - NameSpaces

extension SavedPhotoCollectionViewCell {
    
    private enum Style {
       static let leadingPadding: CGFloat = 8
       static let trailingPadding: CGFloat = -8
       static let cornerRadius: CGFloat = 10
       static let alpha: CGFloat = 0.7
       static let alphaViewHeight: CGFloat = 40
       
       static let selectedStarImage = UIImage(systemName: "star.fill")
   }
}
