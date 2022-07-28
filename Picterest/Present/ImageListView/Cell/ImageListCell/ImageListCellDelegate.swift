//
//  RandomImageListCellDelegate.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/27.
//

import Foundation

protocol ImageListCellDelegate: AnyObject {
    func tappedSaveButton(_ indexPath: IndexPath)
}
