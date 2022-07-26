//
//  LabelStackView.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/26.
//

import UIKit

protocol PhotoEvnetDelegate {
//    func sliderEventValueChanged(sender: UISlider)
}

class LabelStackView: UIStackView {
    
    var delegate: PhotoEvnetDelegate?
    
    private let starButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
        let largeRecordImage = UIImage(systemName: "star", withConfiguration: largeConfig)
        button.setImage(largeRecordImage, for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    private let photoLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationProperties() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .fill
    }
    
    private func layout() {
        [
            starButton, photoLabel
        ].forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: self.topAnchor),
            starButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            starButton.widthAnchor.constraint(equalToConstant: 30),
            starButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            photoLabel.topAnchor.constraint(equalTo: self.topAnchor),
            photoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoLabel.widthAnchor.constraint(equalToConstant: 70),
            photoLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
//    private func addTargetToSlider() {
//        sliderFrequency.addTarget(self, action: #selector(onChangeValueSlider), for: UIControl.Event.valueChanged)
//    }
//
//    private func addTargetToSlider() {
//        sliderFrequency.addTarget(self, action: #selector(onChangeValueSlider), for: UIControl.Event.valueChanged)
//    }
}
