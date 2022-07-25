//
//  PicterestCollectionViewCell.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

class PicterestCollectionViewCell: UICollectionViewCell {
    
    private let picterestImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let cellTopBar: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private let starButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemBackground
        return button
    }()
    
    private let indexTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "n번째 사진"
        label.textColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCellLayout()
    }
    
    private func setCellLayout() {
        self.layer.cornerRadius = self.frame.height/2
        contentView.addSubview(picterestImageView)
        contentView.addSubview(cellTopBar)
        cellTopBar.addArrangedSubview(starButton)
        cellTopBar.addArrangedSubview(indexTitleLabel)
        
        NSLayoutConstraint.activate([
            picterestImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            picterestImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            picterestImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picterestImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellTopBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellTopBar.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            cellTopBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellTopBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellTopBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func fetchImageData(data: ImageData) {
        let image = try! Data(contentsOf: URL(string: data.imageUrl.smallUrl)!)
        picterestImageView.image = UIImage(data: image)
    }
}
