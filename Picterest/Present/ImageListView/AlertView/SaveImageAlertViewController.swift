//
//  InputMessageAlertView.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import UIKit

final class SaveImageAlertViewController: UIViewController {
    
    private enum Define {
        static let savedButtonTitle = " 저장"
        static let cancelButtonTitle = " 취소 "
        static let placeholder = "메시지를 입력하세요"
        static let titleLabelText = "%@번째 사진을 저장하시겠습니까?"
    }
    
    private let alertStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = AlertStyle.Math.cornerRadius
        stackView.backgroundColor = AlertStyle.Color.background
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        return label
    }()
    
    private let inputTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = AlertStyle.Color.textFieldBackground
        textField.placeholder = Define.placeholder
        textField.layer.cornerRadius = AlertStyle.Math.cornerRadius
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: AlertStyle.Math.textFieldLeftPadding, height: 1.0))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
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
        button.setTitle(Define.savedButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Define.cancelButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        button.setTitleColor(.black, for: .normal)
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
        view.backgroundColor = AlertStyle.Color.fakeBackground
        titleLabel.text = String(format: Define.titleLabelText, arguments: [String(row + 1)])
        savedButton.addTarget(self, action: #selector(tappedSavedButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(alertStackView)
        alertStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertStackView.widthAnchor.constraint(equalToConstant: AlertStyle.Math.width).isActive = true
        alertStackView.heightAnchor.constraint(equalToConstant: AlertStyle.Math.height).isActive = true
        [UIView(), titleLabel, inputTextField, buttonContainerStackView, UIView()].forEach {
            alertStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        inputTextField.widthAnchor.constraint(equalToConstant: AlertStyle.Math.textFieldWidth).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: AlertStyle.Math.textFieldHeight).isActive = true
        
        buttonContainerStackView.widthAnchor.constraint(equalToConstant: AlertStyle.Math.width).isActive = true
        
        [savedButton, cancelButton].forEach {
            buttonContainerStackView.addArrangedSubview($0)
        }
    }
}
