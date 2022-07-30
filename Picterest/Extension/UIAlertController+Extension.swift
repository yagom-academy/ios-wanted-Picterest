//
//  UIAlertController.swift
//  Picterest
//
//

import UIKit

extension UIAlertController {
    static func presentSaveAndDeleteAlert(
        title: String,
        message: String,
        isTextField: Bool,
        isLongPress: Bool = false,
        completion: ((UIAlertController) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cofirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?(alert)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion?(alert)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        if isTextField {
            alert.addTextField()
        }
        
        if isLongPress {
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        } else {
            alert.addAction(cofirmAction)
        }
        return alert
    }
}
