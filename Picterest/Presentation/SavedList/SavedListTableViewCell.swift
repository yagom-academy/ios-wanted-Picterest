//
//  SavedListTableViewCell.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import UIKit

class SavedListTableViewCell: UITableViewCell, CellIdentifiable {
    
    private lazy var topView = ImageTopView()
    private lazy var savedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupView(path: String) {
        configUI()
    }
}

private extension SavedListTableViewCell {
    func configUI() {
        [
            topView,
            savedImageView
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            savedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            savedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            savedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            savedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
