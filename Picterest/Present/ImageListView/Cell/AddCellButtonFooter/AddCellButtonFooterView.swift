//
//  SampleFooter.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/26.
//

import UIKit

final class AddCellButtonFooterView: UICollectionReusableView, ReuseIdentifying {
    
    private enum Value {
        static let buttonTitle = "더 보기"
        static let buttonFontSize:CGFloat = 25.0
        static let buttonTitleColor:UIColor = .white
        static let buttonBackgroundColor:UIColor = .systemGray
        static let cornerRadius:CGFloat = 20.0
    }
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Value.buttonTitle, for: .normal)
        button.setTitleColor(Value.buttonTitleColor, for: .normal)
        button.backgroundColor = Value.buttonBackgroundColor
        button.titleLabel?.font = .systemFont(ofSize: Value.buttonFontSize, weight: .medium)
        button.layer.cornerRadius = Value.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: AddCellButtonFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
    }
    
    @objc private func handleAddButton() {
        delegate?.tappedAddCellButton()
    }
    
    private func layout() {
        self.addSubview(addButton)
        addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
