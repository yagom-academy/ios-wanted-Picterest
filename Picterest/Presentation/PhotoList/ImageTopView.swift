//
//  ImageTopView.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

class ImageTopView: UIView {
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.star.image, for: .normal)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(didTapStarButton),
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
    
    func setupView(index: Int) {
        configUI()
        indexLabel.text = "\(index)번째 사진"
    }
}

private extension ImageTopView {
    @objc func didTapStarButton() {
        print("didTapStarButton")
    }
}

private extension ImageTopView {
    func configUI() {
        backgroundColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 0.4)
        
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
