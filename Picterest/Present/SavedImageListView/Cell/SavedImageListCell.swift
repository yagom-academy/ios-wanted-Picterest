//
//  SavedImageListCell.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import UIKit

final class SavedImageListCell: UICollectionViewCell, ReuseIdentifying {
    
    private let topBarStackView = UIStackView()
    private let starButton = UIButton()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    weak var delegate: SavedImageListCellDelegate?
    private var id: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
        addLongTappedGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: CoreDataInfo?) {
        guard let data = data else {
            return
        }
        id = data.id
        titleLabel.text = data.message
        imageView.load(urlString: data.imageURL)
    }

    private func addLongTappedGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTappedGesture))
        gesture.minimumPressDuration = 0.5
        gesture.delaysTouchesBegan = true
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleLongTappedGesture() {
        guard let id = id else {
            return
        }
        delegate?.didLongTappedCell(id: id)
    }
    
    private func attribute() {
        //temp
        starButton.setTitleColor(.yellow, for: .normal)
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        topBarStackView.backgroundColor = .black.withAlphaComponent(0.6)
        topBarStackView.axis = .horizontal
        topBarStackView.alignment = .center
        topBarStackView.distribution = .fill
        
        starButton.setTitle("★", for: .normal)
        starButton.setTitleColor(.yellow, for: .normal)
        starButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        
        titleLabel.textColor = .white
    }
    
    private func layout() {
        [imageView, topBarStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        topBarStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topBarStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topBarStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topBarStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let leftPadding = UIView()
        let rightPadding = UIView()
        
        [leftPadding, starButton, UIView(), titleLabel, rightPadding].forEach {
            topBarStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        leftPadding.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightPadding.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        starButton.widthAnchor.constraint(equalTo: topBarStackView.heightAnchor, multiplier: 0.5).isActive = true
    }
}
