//
//  CellStyle.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/30.
//

import UIKit

enum CellStyle {
    enum Math {
        static let cornerRadius:CGFloat = Style.Math.cornerRadius
        static let topBarHeight:CGFloat = Style.Math.windowWidth < 340 ? 40.0 : 60.0
        static let topBarLeftPadding:CGFloat = Style.Math.windowWidth < 340 ? 10.0 : 20.0
        static let topBarRightPadding:CGFloat = Style.Math.windowWidth < 340 ? 10.0 : 20.0
        static let starButtonSize:CGFloat = topBarHeight/2
        static let largePadding:CGFloat = 10.0
        static let largeWidth:CGFloat = Style.Math.windowWidth - 2*largePadding
    }
    enum Color {
        static let text:UIColor = Style.Color.text
        static let topBarBackground:UIColor = .black.withAlphaComponent(0.6)
    }
}
