//
//  InputMessageAlertView.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import UIKit

final class SaveImageAlertViewController: UIViewController {
    enum Value {
        static let alertWidth = UIScreen.main.bounds.width*(2/3)
        static let alertHeight = alertWidth*(2/3)
        static let textFieldLeftPadding = 10.0
        static let cornerRadius = 15.0
        static let savedButtonTitle = " 저장"
        static let cancelButtonTitle = " 취소 "
        static let placeholder = "메시지를 입력하세요"
    }
    private let alertStackView = UIStackView()
    private let titleLabel = UILabel()
    private let inputTextField = UITextField()
    
    private let buttonContainerStackView = UIStackView()
    private let savedButton = UIButton()
    private let cancelButton = UIButton()
    
    weak var delegate: SaveImageAlertViewDelegate?
    private let row: Int
    
    init(row: Int) {
        self.row = row
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
    
    @objc private func tappedSavedButton() {
        delegate?.tappedSavedButton(row: row, message: inputTextField.text ?? "")
        dismiss(animated: false)
    }
    
    @objc private func tappedCancelButton() {
        dismiss(animated: false)
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.2)
        
        alertStackView.layer.cornerRadius = Value.cornerRadius
        alertStackView.backgroundColor = .green
        alertStackView.axis = .vertical
        alertStackView.alignment = .center
        alertStackView.distribution = .equalSpacing
        
        buttonContainerStackView.axis = .horizontal
        buttonContainerStackView.distribution = .fillEqually
        
        titleLabel.text = "\(row+1)번째 사진을 저장하시겠습니까?"
        titleLabel.textAlignment = .center
        
        inputTextField.backgroundColor = .white
        inputTextField.placeholder = Value.placeholder
        inputTextField.layer.cornerRadius = Value.cornerRadius
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Value.textFieldLeftPadding, height: inputTextField.frame.height))
        inputTextField.leftViewMode = .always
        
        savedButton.setTitle(Value.savedButtonTitle, for: .normal)
        savedButton.addTarget(self, action: #selector(tappedSavedButton), for: .touchUpInside)
        
        cancelButton.setTitle(Value.cancelButtonTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func layout() {
        setAlertFrame()

        view.addSubview(alertStackView)
        [UIView(), titleLabel, inputTextField, buttonContainerStackView, UIView()].forEach {
            alertStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        inputTextField.widthAnchor.constraint(equalToConstant: Value.alertWidth*7/8).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: Value.alertHeight/4).isActive = true
        
        buttonContainerStackView.widthAnchor.constraint(equalToConstant: Value.alertWidth).isActive = true
        
        [savedButton, cancelButton].forEach {
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
