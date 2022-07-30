//
//  AlertStyle.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/30.
//

import UIKit

enum AlertStyle {
    enum Math {
        static let width:CGFloat = Style.Math.windowWidth*(2/3)
        static let height:CGFloat = width/2
        static let cornerRadius:CGFloat = Style.Math.cornerRadius - 5.0
        static let textFieldWidth:CGFloat = width*(7/8)
        static let textFieldHeight:CGFloat = height/4
        static let textFieldLeftPadding:CGFloat = 10.0
    }
    enum Color {
        static let fakeBackground:UIColor = .white.withAlphaComponent(0.2)
        static let background:UIColor = Style.Color.brown
        static let text:UIColor = Style.Color.text
        static let button:UIColor = Style.Color.darkBrown
        static let textFieldBackground:UIColor = .white
    }
}
