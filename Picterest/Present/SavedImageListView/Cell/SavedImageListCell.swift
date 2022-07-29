//
//  SavedImageListCell.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import UIKit

private enum Value {
    enum Math {
        static let starButtonFontSize:CGFloat = 30.0
        static let longGestureMinimumPressDuration:CGFloat = 0.5
        static let cornerRadius:CGFloat = 20.0
        static let topBarStackViewHeight:CGFloat = 60.0
        static let sidePadding:CGFloat = 20.0
        static let starButtonSize:CGFloat = topBarStackViewHeight/2
    }
    
    enum Text {
        static let starButtonTitle = "★"
    }
    
    enum Style {
        static let topBarBackgroundColor:UIColor = .black.withAlphaComponent(0.6)
        static let starButtonTitleColor:UIColor = .yellow
        static let titleLabelColor:UIColor = .white
    }
}

final class SavedImageListCell: UICollectionViewCell, ReuseIdentifying {
    
    private let topBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Value.Style.topBarBackgroundColor
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setTitle(Value.Text.starButtonTitle, for: .normal)
        button.setTitleColor(Value.Style.starButtonTitleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Value.Math.starButtonFontSize, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Value.Style.titleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        titleLabel.text = ""
        imageView.image = nil
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
        gesture.minimumPressDuration = Value.Math.longGestureMinimumPressDuration
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
        contentView.layer.cornerRadius = Value.Math.cornerRadius
        contentView.clipsToBounds = true
    }
    
    private func layout() {
        [imageView, topBarStackView].forEach {
            contentView.addSubview($0)
        }
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        topBarStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topBarStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topBarStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topBarStackView.heightAnchor.constraint(equalToConstant: Value.Math.topBarStackViewHeight).isActive = true
        
        let leftPadding = UIView()
        leftPadding.translatesAutoresizingMaskIntoConstraints = false
        let rightPadding = UIView()
        rightPadding.translatesAutoresizingMaskIntoConstraints = false
        
        [leftPadding, starButton, UIView(), titleLabel, rightPadding].forEach {
            topBarStackView.addArrangedSubview($0)
        }
        
        leftPadding.widthAnchor.constraint(equalToConstant: Value.Math.sidePadding).isActive = true
        rightPadding.widthAnchor.constraint(equalToConstant: Value.Math.sidePadding).isActive = true
        
        starButton.widthAnchor.constraint(equalToConstant: Value.Math.starButtonSize).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: Value.Math.starButtonSize).isActive = true
    }
}
