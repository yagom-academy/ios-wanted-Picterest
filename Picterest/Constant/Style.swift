//
//  Style.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import UIKit

struct Style {
    struct CellView {
        static let headerViewHeight: CGFloat = UIScreen.main.bounds.size.height / 20
        static let headerViewAlpha: CGFloat = 0.7
        static let saveButtonHeight: CGFloat = headerViewHeight * 0.5
        static let trailingConstant: CGFloat = -10
        static let leadingConstant: CGFloat = 10
        static let cornerRadius: CGFloat = 20
        static let fontSize: CGFloat = headerViewHeight * 0.4
    }
    
    struct Cell {
        static let trailingconstant: CGFloat = -2
        static let leadingConstant: CGFloat = 2
        static let topConstant: CGFloat = 2
        static let bottomConstant: CGFloat = 2
    }
    
    struct SavedCell {
        static let width: CGFloat = UIScreen.main.bounds.size.width * 0.94
    }
}
