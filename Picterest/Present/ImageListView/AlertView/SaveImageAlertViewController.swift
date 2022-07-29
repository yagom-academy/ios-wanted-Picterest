//
//  InputMessageAlertView.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import UIKit

private enum Value {
    enum Math {
        static let alertWidth = UIScreen.main.bounds.width*(2/3)
        static let alertHeight = alertWidth*(2/3)
        static let inputTextFieldWidth = alertWidth*(7/8)
        static let inputTextFieldHeight = alertHeight/4
        static let textFieldLeftPadding = 10.0
        static let cornerRadius = 15.0
    }
    enum Text {
        static let savedButtonTitle = " 저장"
        static let cancelButtonTitle = " 취소 "
        static let placeholder = "메시지를 입력하세요"
        static let titleLabelText = "%@번째 사진을 저장하시겠습니까?"
    }
    enum Style {
        static let backgroundColor:UIColor = .white.withAlphaComponent(0.2)
        static let alertStackViewBackgroundColor:UIColor = .green
        static let inputTextFieldBackgroundColor:UIColor = .white
    }
}

final class SaveImageAlertViewController: UIViewController {
    
    private let alertStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = Value.Math.cornerRadius
        stackView.backgroundColor = Value.Style.alertStackViewBackgroundColor
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let inputTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = Value.Style.inputTextFieldBackgroundColor
        textField.placeholder = Value.Text.placeholder
        textField.layer.cornerRadius = Value.Math.cornerRadius
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Value.Math.textFieldLeftPadding, height: 1.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let buttonContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let savedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Value.Text.savedButtonTitle, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Value.Text.cancelButtonTitle, for: .normal)
        return button
    }()
    
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
        view.backgroundColor = Value.Style.backgroundColor
        titleLabel.text = String(format: Value.Text.titleLabelText, arguments: [String(row + 1)])
        savedButton.addTarget(self, action: #selector(tappedSavedButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(alertStackView)
        alertStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertStackView.widthAnchor.constraint(equalToConstant: Value.Math.alertWidth).isActive = true
        alertStackView.heightAnchor.constraint(equalToConstant: Value.Math.alertHeight).isActive = true
        [UIView(), titleLabel, inputTextField, buttonContainerStackView, UIView()].forEach {
            alertStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        inputTextField.widthAnchor.constraint(equalToConstant: Value.Math.inputTextFieldWidth).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: Value.Math.inputTextFieldHeight).isActive = true
        
        buttonContainerStackView.widthAnchor.constraint(equalToConstant: Value.Math.alertWidth).isActive = true
        
        [savedButton, cancelButton].forEach {
            buttonContainerStackView.addArrangedSubview($0)
        }
    }
}
