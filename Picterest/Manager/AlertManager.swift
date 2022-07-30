//
//  AlertManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/30.
//

import UIKit

struct AlertManager {
    
    private var alertTitle: String?
    private var alertMessage: String
    
    init(
        alertTitle: String? = nil,
        alertMessage: String
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
    }
    
    func createAlert(isSave: Bool, okAction: @escaping ((UIAlertController) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            okAction(alert)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        if isSave {
            alert.addTextField()
        }
        
        return alert
    }
}
