//
//  SampleFooter.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/26.
//

import UIKit

final class AddCellButtonFooterView: UICollectionReusableView, ReuseIdentifying {
    
    private let addButton = UIButton(type: .system)
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
        backgroundColor = .systemGray
        layer.cornerRadius = 20
        addButton.setTitle(" 더 보기 ", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
    }
    
    @objc private func handleAddButton() {
        delegate?.tappedAddCellButton()
    }
    
    private func layout() {
        self.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
