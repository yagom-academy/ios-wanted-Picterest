//
//  ImageCollectionViewCellDescriptionView.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

final class ImageCollectionViewCellDescriptionView: UIView {
    
    // MARK: - ViewProperties
    let starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .yellow
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    private let alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        
        return view
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubViews()
        setConstraintsOfStarButton()
        setConstraintsOfDescriptionLabel()
        setConstraintsOfAlphaView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Method
extension ImageCollectionViewCellDescriptionView {
    func configureView(index: Int, isStar: Bool) {
        descriptionLabel.text = "\(index)번째 사진"
        starButton.isSelected = isStar
    }
    
    func configureView(memo: String) {
        starButton.isSelected = true
        descriptionLabel.text = memo
    }
}

// MARK: - UI
extension ImageCollectionViewCellDescriptionView {
    private func configureSubViews() {
        [alphaView, starButton, descriptionLabel].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.addSubview($0)
        }
    }
    
    private func setConstraintsOfAlphaView() {
        NSLayoutConstraint.activate([
            alphaView.topAnchor.constraint(equalTo: self.topAnchor),
            alphaView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            alphaView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    private func setConstraintsOfStarButton() {
        NSLayoutConstraint.activate([
            starButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            starButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 35),
            starButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setConstraintsOfDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
}
