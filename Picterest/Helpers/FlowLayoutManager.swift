//
//  LayoutManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

protocol LayoutProvidable {
  func createSection() -> NSCollectionLayoutSection?
}

struct FlowLayoutManager {
  
  static func makeCompositionalLayout(_ provider: LayoutProvidable) -> UICollectionViewCompositionalLayout {
    
    let layout = UICollectionViewCompositionalLayout { (_ , _) -> NSCollectionLayoutSection? in
      guard let section = provider.createSection() else {return nil}
      return section
    }
    
    return layout
  }
}


struct HomeSceneLayout: LayoutProvidable {
  
  func createSection() -> NSCollectionLayoutSection? {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(300))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
}
