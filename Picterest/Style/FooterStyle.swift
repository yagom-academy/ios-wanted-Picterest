//
//  FooterStyle.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/30.
//

import UIKit

enum FooterStyle {
    enum Math {
        static let cornerRadius:CGFloat = Style.Math.cornerRadius
        static let height:CGFloat = Style.Math.windowWidth < 340 ? 60.0 : 80.0
    }
    enum Color {
        static let text:UIColor = Style.Color.text
        static let backgroundColor:UIColor = .systemGray
    }
}
