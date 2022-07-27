//
//  SavedListTableViewCell.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import UIKit

class SavedListTableViewCell: UITableViewCell, CellIdentifiable {
    
    private lazy var topView: ImageTopView = {
        let view = ImageTopView()
        view.layer.cornerRadius = 10.0
        return view
    }()
    private lazy var savedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupView(savedPhoto: CoreSavedPhoto) {
        guard let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("SavedPhotos") else { return }
        
        let writeURL = folderURL.appendingPathComponent(savedPhoto.id + ".png")
        print(writeURL)
        let data = FileManager.default.contents(atPath: writeURL.path)
        
        savedImageView.image = UIImage(data: data!)
        
        configUI()
        topView.setupView(index: 1)
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
        
        contentView.bringSubviewToFront(topView)
        
        NSLayoutConstraint.activate([
            topView
                .leadingAnchor
                .constraint(equalTo: savedImageView.leadingAnchor),
            topView
                .topAnchor
                .constraint(equalTo: savedImageView.topAnchor),
            topView
                .trailingAnchor
                .constraint(equalTo: savedImageView.trailingAnchor),
            
            savedImageView
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            savedImageView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 16.0),
            savedImageView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            savedImageView
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            savedImageView
                .heightAnchor
                .constraint(
                    equalTo: savedImageView.widthAnchor,
                    multiplier:
                        (savedImageView.image!.size.height / savedImageView.image!.size.width)
                )
        ])
    }
}
