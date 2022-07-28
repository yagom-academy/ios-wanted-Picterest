//
//  CellView.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import UIKit

final class CellView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        autoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.tintColor = .black
        headerView.isOpaque = false
        headerView.alpha = 0.5
        return headerView
    }()
    
    let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(systemName: "star"), for: .normal)
        saveButton.tintColor = .white
        saveButton.isOpaque = true
        return saveButton
    }()
    
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = ""
        return textLabel
    }()
    
    private func setView() {
        self.addSubview(imageView)
        self.addSubview(headerView)
        self.addSubview(saveButton)
        self.addSubview(textLabel)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            saveButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            saveButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            textLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
}
