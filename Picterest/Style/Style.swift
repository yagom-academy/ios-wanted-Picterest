//
//  Style.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/30.
//

import UIKit

enum Style {
    enum Math {
        static let cornerRadius:CGFloat = 20.0
        static let windowWidth:CGFloat = UIScreen.main.bounds.width
    }
    
    enum Font {
        static let medium:CGFloat = Math.windowWidth < 340 ? 12.0 : 16.0
        static let large:CGFloat = Math.windowWidth < 340 ? 20.0 : 25.0
    }
    
    enum Color {
        static let text:UIColor = .white
        static let tint:UIColor = .white
        static let selectedStar:UIColor = .systemYellow
        static let deSelectedStar:UIColor = .white
        static let background:UIColor = .white
        static let collectionViewBackground:UIColor = .clear
        static let brown:UIColor = .init(red: 110/256, green: 77/256, blue: 65/256, alpha: 1)
        static let darkBrown:UIColor = .init(red: 64/256, green: 36/256, blue: 26/256, alpha: 1)
    }
}
