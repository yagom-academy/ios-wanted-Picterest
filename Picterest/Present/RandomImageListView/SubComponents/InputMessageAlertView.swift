//
//  InputMessageAlertView.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import UIKit

final class InputMessageAlertViewController: UIViewController {
    private let alertView = UIView()
    private let titleLabel = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.map({ $0.view }).contains(alertView) == false {
            dismiss(animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.2)
        alertView.backgroundColor = .green
    }
    
    private func layout() {
        setAlertFrame()

        view.addSubview(alertView)
    }
    
    private func setAlertFrame() {
        let width = 300.0
        let height = 200.0
        let x = (UIScreen.main.bounds.width-width)/2.0
        let y = (UIScreen.main.bounds.height-height)/2.0
        alertView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
