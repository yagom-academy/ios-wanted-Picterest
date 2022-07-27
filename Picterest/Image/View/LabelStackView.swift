//
//  LabelStackView.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/26.
//

import UIKit

protocol PhotoLabelEvnetDelegate {
    func tapStarButton(sender: UIButton)
}

class LabelStackView: UIStackView {
    
    var delegate: PhotoLabelEvnetDelegate?
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    let photoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        configurationProperties()
        layout()
        addTargetStarButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationProperties() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        self.layer.cornerRadius = 10
        self.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    private func layout() {
        [
            starButton, photoLabel
        ].forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addTargetStarButton() {
        starButton.addTarget(self, action: #selector(tapStarButton), for: .touchUpInside)
    }

    @objc func tapStarButton() {
        delegate?.tapStarButton(sender: starButton)
    }
}
