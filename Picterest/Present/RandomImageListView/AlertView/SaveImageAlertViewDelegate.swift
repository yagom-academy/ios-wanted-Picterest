//
//  InputMessageAlertViewDelegate.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import Foundation

protocol SaveImageAlertViewDelegate: AnyObject {
    func tappedSavedButton(row: Int, message: String)
}
