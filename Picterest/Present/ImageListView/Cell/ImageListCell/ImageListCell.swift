//
//  RandomImageListCollectionViewCell.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class ImageListCell: UICollectionViewCell, ReuseIdentifying {
    
    private enum Define {
        static let titleLabelText = "%@번째 사진"
        static let starButtonSelected = "★"
        static let starButtonDeSelected = "☆"
    }
    
    private let topBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = CellStyle.Color.topBarBackground
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: Style.Font.starButton, weight: .medium)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CellStyle.Color.text
        label.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        return label
    }()
    
    private let imageView = UIImageView()
    
    private var row: Int?
    
    weak var delegate: ImageListCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        delegate = nil
        imageView.image = nil
    }
    
    func configure(row: Int, data: ImageListViewModel.CellData?) {
        guard let data = data else {
            return
        }
        self.row = row
        titleLabel.text = String(format: Define.titleLabelText, arguments: [String(row + 1)])
        imageView.load(urlString: data.thumbnailURL)
        starButton.setTitleColor(data.isSaved ? Style.Color.selectedStar : Style.Color.deSelectedStar, for: .normal)
        starButton.setTitle(data.isSaved ? Define.starButtonSelected: Define.starButtonDeSelected, for: .normal)
    }
    
    private func attribute() {
        contentView.layer.cornerRadius = CellStyle.Math.cornerRadius
        contentView.clipsToBounds = true
        
        starButton.addTarget(self, action: #selector(tappedStarButton), for: .touchUpInside)
    }
    
    @objc private func tappedStarButton() {
        guard let row = row else {
            return
        }
        delegate?.tappedSaveButton(row)
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
        topBarStackView.heightAnchor.constraint(equalToConstant: CellStyle.Math.topBarHeight).isActive = true
        
        let leftPadding = UIView()
        let rightPadding = UIView()
        
        [leftPadding, starButton, UIView(), titleLabel, rightPadding].forEach {
            topBarStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        leftPadding.widthAnchor.constraint(equalToConstant: CellStyle.Math.topBarLeftPadding).isActive = true
        rightPadding.widthAnchor.constraint(equalToConstant: CellStyle.Math.topBarRightPadding).isActive = true
        
        starButton.widthAnchor.constraint(equalToConstant: CellStyle.Math.starButtonSize).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: CellStyle.Math.starButtonSize).isActive = true
    }
}
