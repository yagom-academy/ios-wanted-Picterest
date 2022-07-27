//
//  RandomImageListCellDelegate.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import Foundation

protocol RandomImageListCellDelegate: AnyObject {
    func tappedSaveButton(_ indexPath: IndexPath)
}
