//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var imageCoverView: UIView = {
        let imageCoverView = UIView()
        imageCoverView.translatesAutoresizingMaskIntoConstraints = false
        imageCoverView.backgroundColor = .black
        imageCoverView.alpha = 0.2
        
        return imageCoverView
    }()
    
    private lazy var saveStarButton: UIButton = {
        let saveStarButton = UIButton()
        saveStarButton.translatesAutoresizingMaskIntoConstraints = false
        saveStarButton.imageView?.image = UIImage(systemName: "star")
        
        return saveStarButton
    }()
    
    lazy var imageTitleOrIndexLabel: UILabel = {
        let imageTitleOrIndexLabel = UILabel()
        imageTitleOrIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTitleOrIndexLabel.textColor = .white
        imageTitleOrIndexLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        return imageTitleOrIndexLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        autoLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with imageViewModel : ImageViewModel){
        self.imageView.load(url: imageViewModel.url)
    }
    
    func addView(){
        self.contentView.addSubview(imageView)
        imageView.addSubview(imageCoverView)
        imageCoverView.addSubview(saveStarButton)
        imageCoverView.addSubview(imageTitleOrIndexLabel)
    }
    
    func autoLayOut(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageCoverView.topAnchor.constraint(equalTo: imageView.topAnchor),
            imageCoverView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageCoverView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageCoverView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.2),
            
            saveStarButton.centerYAnchor.constraint(equalTo: imageCoverView.centerYAnchor),
            saveStarButton.leadingAnchor.constraint(equalTo: imageCoverView.leadingAnchor, constant: 5),
            
            imageTitleOrIndexLabel.centerYAnchor.constraint(equalTo: imageCoverView.centerYAnchor),
            imageTitleOrIndexLabel.trailingAnchor.constraint(equalTo: imageCoverView.trailingAnchor, constant: -5)
        ])
    }
}
