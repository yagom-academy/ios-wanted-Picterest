//
//  CheckRemoveAlertViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/29.
//

import UIKit

private enum Value {
    static let alertWidth = UIScreen.main.bounds.width*(2/3)
    static let alertHeight = alertWidth*(2/3)
    static let titleLabelText = "정말로 이미지를 삭제하시겠습니까?"
    static let removeButtonTitle = " 삭제 "
    static let cancelButtonTitle = " 취소 "
}

final class CheckRemoveAlertViewController: UIViewController {
    
    private let alertStackView = UIStackView()
    private let titleLabel = UILabel()
    private let buttonContainerStackView = UIStackView()
    private let removeButton = UIButton()
    private let cancelButton = UIButton()
    
    weak var delegate: CheckRemoveAlertViewDelegate?
    private let id: UUID
    
    init(id: UUID) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.map({ $0.view }).contains(alertStackView) == false {
            dismiss(animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedRemoveButton() {
        delegate?.tappedRemoveButton(id: id)
        dismiss(animated: false)
    }
    
    @objc private func tappedCancelButton() {
        dismiss(animated: false)
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.2)
        
        alertStackView.layer.cornerRadius = 20
        alertStackView.backgroundColor = .green
        alertStackView.axis = .vertical
        alertStackView.alignment = .center
        alertStackView.distribution = .equalSpacing
        
        buttonContainerStackView.axis = .horizontal
        buttonContainerStackView.distribution = .fillEqually
        
        titleLabel.text = Value.titleLabelText
        titleLabel.textAlignment = .center
        
        removeButton.setTitle(Value.removeButtonTitle, for: .normal)
        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
        cancelButton.setTitle(Value.cancelButtonTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func layout() {
        setAlertFrame()

        view.addSubview(alertStackView)
        [UIView(), titleLabel, buttonContainerStackView, UIView()].forEach {
            alertStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        buttonContainerStackView.widthAnchor.constraint(equalToConstant: Value.alertWidth-20).isActive = true
        
        [removeButton, cancelButton].forEach {
            buttonContainerStackView.addArrangedSubview($0)
        }
    }
    
    private func setAlertFrame() {
        let width = Value.alertWidth
        let height = Value.alertHeight
        let x = (UIScreen.main.bounds.width-width)/2.0
        let y = (UIScreen.main.bounds.height-height)/2.0
        alertStackView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
