//
//  CellView.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import UIKit

final class CellView: UIView {
    
    var isSaved: Bool = false
    
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
        return imageView
    }()
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .black
        headerView.isOpaque = false
        headerView.alpha = Style.CellView.headerViewAlpha
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
        textLabel.textAlignment = .right
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: Style.CellView.fontSize)
        return textLabel
    }()
    
    private func setView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Style.CellView.cornerRadius
        self.addSubview(imageView)
        self.addSubview(headerView)
        self.addSubview(saveButton)
        self.addSubview(textLabel)
        self.bringSubviewToFront(headerView)
        self.bringSubviewToFront(textLabel)
        self.bringSubviewToFront(saveButton)
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
            headerView.heightAnchor.constraint(equalToConstant: Style.CellView.headerViewHeight),
            
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Style.CellView.leadingConstant),
            saveButton.widthAnchor.constraint(equalToConstant: Style.CellView.saveButtonHeight),
            saveButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Style.CellView.saveButtonHeight),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Style.CellView.trailingConstant),
            textLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
}
