//
//  UIAlertController+.swift
//  Picterest
//
//  Created by yc on 2022/07/28.
//

import UIKit

extension UIAlertController {
    static func showAlert(
        _ target: UIViewController?,
        title: String,
        isInTextField: Bool,
        handler: @escaping (String?
        ) -> Void) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        if isInTextField {
            alert.addTextField()
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            handler(alert.textFields?.first?.text)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        [okAction, cancelAction].forEach { alert.addAction($0) }
        target?.present(alert, animated: true)
    }
}
