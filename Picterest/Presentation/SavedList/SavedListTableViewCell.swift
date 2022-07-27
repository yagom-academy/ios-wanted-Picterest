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
    
    func setupView(savedPhoto: CoreSavedPhoto) {
        configUI()
        
        guard let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("SavedPhotos") else { return }
        
        let writeURL = folderURL.appendingPathComponent(savedPhoto.id + ".png")
        
        let data = FileManager.default.contents(atPath: writeURL.path)
        
        savedImageView.image = UIImage(data: data!)
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
            
            savedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            savedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            savedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            savedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
        ])
    }
}
