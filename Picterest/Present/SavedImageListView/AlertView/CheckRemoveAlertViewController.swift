//
//  CheckRemoveAlertViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/29.
//

import UIKit

private enum Value {
    enum Text {
        static let titleLabelText = "정말로 이미지를 삭제하시겠습니까?"
        static let removeButtonTitle = " 삭제 "
        static let cancelButtonTitle = " 취소 "
    }
}

final class CheckRemoveAlertViewController: UIViewController {
    
    private let alertStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = AlertStyle.Math.cornerRadius
        stackView.backgroundColor = .green
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Value.Text.titleLabelText
        label.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let buttonContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Value.Text.removeButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Value.Text.cancelButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Style.Font.medium, weight: .medium)
        return button
    }()
    
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
        view.backgroundColor = AlertStyle.Color.fakeBackground
        
        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(alertStackView)
        alertStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertStackView.widthAnchor.constraint(equalToConstant: AlertStyle.Math.width).isActive = true
        alertStackView.heightAnchor.constraint(equalToConstant: AlertStyle.Math.height).isActive = true
        [UIView(), titleLabel, buttonContainerStackView, UIView()].forEach {
            alertStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        buttonContainerStackView.widthAnchor.constraint(equalToConstant: AlertStyle.Math.width).isActive = true
        
        [removeButton, cancelButton].forEach {
            buttonContainerStackView.addArrangedSubview($0)
        }
    }
}
