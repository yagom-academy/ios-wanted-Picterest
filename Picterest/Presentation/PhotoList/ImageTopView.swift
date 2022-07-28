//
//  ImageTopView.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

class ImageTopView: UIView {
    // MARK: - UI Components
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.star.image, for: .normal)
        button.setImage(Icon.starFill.image, for: .selected)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(didTapStarButton(_:)),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    var viewModel: ImageTopViewModel?
    
    // MARK: - Setup
    func setupView(text: String) {
        configUI()
        indexLabel.text = text
    }
    func fillStarButton() {
        starButton.isSelected = true
        starButton.tintColor = .systemYellow
    }
    func initView() {
        starButton.isSelected = false
        starButton.tintColor = .white
        indexLabel.text = nil
    }
}

// MARK: - @objc Methods
private extension ImageTopView {
    @objc func didTapStarButton(_ sender: UIButton) {
        print("didTapStarButton")
        viewModel?.starButtonTapped.value = sender
    }
}

// MARK: - UI Methods
private extension ImageTopView {
    func configUI() {
        backgroundColor = .systemFill
        
        [
            starButton,
            indexLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            starButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            starButton.topAnchor.constraint(equalTo: topAnchor),
            starButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 44.0),
            starButton.heightAnchor.constraint(equalToConstant: 44.0),
            
            indexLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor),
            indexLabel.topAnchor.constraint(equalTo: starButton.topAnchor),
            indexLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            indexLabel.bottomAnchor.constraint(equalTo: starButton.bottomAnchor)
        ])
    }
}
