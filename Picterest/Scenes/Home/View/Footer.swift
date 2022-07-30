//
//  Footer.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/27.
//

import UIKit

class Footer: UICollectionReusableView {
  static let id = "Footer"
  
  let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.style = .large
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    self.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
