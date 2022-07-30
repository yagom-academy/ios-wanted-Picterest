//
//  IndecatorView.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/27.
//

import UIKit

class PhotoCollectionIndecatorView: UICollectionReusableView {
    
    static let identifier = "PhotoCollectionIndecatorView"
    
    private let spinner : UIActivityIndicatorView = {
        let Indicator = UIActivityIndicatorView()
        Indicator.startAnimating()
        return Indicator
    }()
    
    func configure() {
        addSubview(spinner)
    }
    
    override func layoutSubviews() {
        spinner.center = self.center
    }

}
