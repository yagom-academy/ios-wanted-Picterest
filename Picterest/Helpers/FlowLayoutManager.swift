//
//  LayoutManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

protocol HomeSceneLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class HomeSceneLayout: UICollectionViewLayout {
  
  // 1
  weak var delegate: HomeSceneLayoutDelegate?
  
  // 2
  private let numberOfColumns = 2
  private let cellPadding: CGFloat = 6
  
  // 3
  private var cache: [UICollectionViewLayoutAttributes] = []
  
  // 4
  // contentHeight = collection view 의 전체 height. -> 사진이 더해지면서 커점.
  private var contentHeight: CGFloat = 0
  
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  // 5
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  
  //6
  override func prepare() {
    guard cache.isEmpty,
          let collectionView = collectionView
    else {
      return
    }
    
    //7
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

    //8
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      
      //9
      let photoHeight = delegate?.collectionView(
        collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = cellPadding * 2 + photoHeight / 2
      
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      //10
      let attributes = UICollectionViewLayoutAttributes(forCellWith:
                                                          indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      //11
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      let otherCol = column == 0 ? 1:0
      column = yOffset[column] < yOffset[otherCol] ? column : otherCol
  
    }
  }
  
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath)
      -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}


