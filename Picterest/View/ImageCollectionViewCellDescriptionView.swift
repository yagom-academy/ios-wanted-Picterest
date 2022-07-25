//
//  ImageCollectionViewCellDescriptionView.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

final class ImageCollectionViewCellDescriptionView: UIView {
    
    // MARK: - ViewProperties
    private let starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .yellow
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1번째 사진"
        
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubViews()
        setConstraintsOfStarButton()
        setConstraintsOfDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI
extension ImageCollectionViewCellDescriptionView {
    private func configureSubViews() {
        [starButton, descriptionLabel].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.addSubview($0)
        }
    }
    
    private func setConstraintsOfStarButton() {
        NSLayoutConstraint.activate([
            starButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            starButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 35),
            starButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setConstraintsOfDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
}
