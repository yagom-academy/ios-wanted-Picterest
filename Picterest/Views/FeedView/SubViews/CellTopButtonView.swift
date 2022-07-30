//
//  CellTopButtonView.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/27.
//

import UIKit

// MARK: - Cell Top Button Delegate
protocol CellTopButtonDelegate: AnyObject {
    func CellTopButton(to starButton: UIButton)
}

class CellTopButtonView: UIView {
    // MARK: - Properties
    weak var delegate: CellTopButtonDelegate?
    
    // MARK: - View Properties
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.starImage, for: .normal)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(didTapStarButton(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Objc Methods
private extension CellTopButtonView {
    @objc func didTapStarButton(_ sender: UIButton) {
        delegate?.CellTopButton(to: sender)
    }
}

// MARK: - UI Methods
private extension CellTopButtonView {
    func configureUI() {
        [
            starButton,
            indexLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            starButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 10),
            starButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            starButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            indexLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -10),
            indexLabel.centerYAnchor.constraint(equalTo: starButton.centerYAnchor)
        ])
        
        
    }
}
