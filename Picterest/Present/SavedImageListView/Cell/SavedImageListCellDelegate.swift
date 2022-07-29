//
//  SavedImageListCellDelegate.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/29.
//

import Foundation

protocol SavedImageListCellDelegate: AnyObject {
    func didLongTappedCell(id: UUID)
}
