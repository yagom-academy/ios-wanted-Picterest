//
//  CellStyle.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/30.
//

import UIKit

enum CellStyle {
    enum Math {
        static let cornerRadius:CGFloat = Style.Math.windowWidth < 340 ? 10.0 : 15.0
        static let topBarHeight:CGFloat = Style.Math.windowWidth < 340 ? 40.0 : 60.0
        static let smallCellTopBarSidePadding:CGFloat = Style.Math.windowWidth < 340 ? 8.0 : 10.0
        static let largeCellTopBarSidePadding:CGFloat = Style.Math.windowWidth < 340 ? 15.0 : 20.0
        static let starButtonSize:CGFloat = topBarHeight/2
        static let cellPadding:CGFloat = 10.0
        static let cellWidth:CGFloat = Style.Math.windowWidth - 2*cellPadding
    }
    enum Font {
        static let starButton:CGFloat = Style.Math.windowWidth < 340 ? 20.0 : 25.0
    }
    enum Color {
        static let text:UIColor = Style.Color.text
        static let topBarBackground:UIColor = .black.withAlphaComponent(0.6)
    }
}
