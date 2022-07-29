//
//  AlertViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/29.
//

import UIKit

enum AlertType {
    case confirmAndCancel
    case confirm
    case confirmTextField
}

protocol AlertAble: AnyObject {
    var titleText: String? { get }
    var messageText: String? { get }
    var alertType: AlertType { get }
}

class AlertViewController: UIViewController, AlertAble {
    var titleText: String?
    var messageText: String?
    var alertType: AlertType
    var completion: (String?) -> ()
    
    init(
        titleText: String?,
        messageText: String?,
        alertType: AlertType = .confirm,
        completion: @escaping (String?) -> ()
    ) {
        self.titleText = titleText
        self.messageText = messageText
        self.alertType = alertType
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .left
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    @objc func didTapConfirmButton() {
        completion(inputTextField.text)
        self.dismiss(animated: true)
    }
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonStackView()
        configureContentView()
        configureUI()
    }
    
    func configureContentView() {
        switch alertType {
        case .confirmAndCancel, .confirm:
            [titleLabel,messageLabel,buttonStackView].forEach {
                containerStackView.addArrangedSubview($0)
            }
        case .confirmTextField:
            [titleLabel,messageLabel,inputTextField,buttonStackView].forEach {
                containerStackView.addArrangedSubview($0)
            }
        }
    }
    
    func configureButtonStackView() {
        switch alertType {
        case .confirmAndCancel, .confirmTextField:
            [cancelButton,confirmButton].forEach {
                buttonStackView.addArrangedSubview($0)
            }
        case .confirm:
            buttonStackView.addArrangedSubview(confirmButton)
        }
        
        confirmButton.backgroundColor = .systemBlue
        cancelButton.backgroundColor = .secondarySystemBackground
        
        confirmButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        
        buttonStackView.spacing = 10
    }
    
    func configureUI() {
        containerView.addSubview(containerStackView)
        [containerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.addSubview(containerStackView)
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -32),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor,constant: 32),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor,constant: -32),
            
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -24),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -24),

            buttonStackView.heightAnchor.constraint(equalToConstant: 30),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
        
        if alertType == .confirmTextField {
            NSLayoutConstraint.activate([
                inputTextField.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            ])
        }
    }
    
}
