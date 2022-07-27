//
//  LayoutManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

protocol SceneLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

enum LayoutType: Int {
  case save = 1
  case home
}

final class SceneLayout: UICollectionViewLayout {
  
  // 1
  weak var delegate: SceneLayoutDelegate?
  
  // 2
  let numberOfColumns: Int
  let cellPadding: CGFloat
  
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
  
  init(scene: LayoutType, cellPadding: CGFloat){
    self.numberOfColumns = scene.rawValue
    self.cellPadding = cellPadding
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


extension SceneLayout {
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    super.prepare()
    guard let collectionView = collectionView
    else {
      return
    }
    

    let columnWidth = (contentWidth / CGFloat(numberOfColumns))
    
    var xOffset: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
    

      for item in 0..<collectionView.numberOfItems(inSection: 0) {
        let indexPath = IndexPath(item: item, section: 0)
        
        //9
        let photoHeight = delegate?.collectionView(
          collectionView, heightForPhotoAtIndexPath: indexPath) ?? 0
        let height = cellPadding * 2 + photoHeight
        
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
        if numberOfColumns == 1 {continue}
        let otherCol = column == 0 ? 1:0
        column = yOffset[column] < yOffset[otherCol] ? column : otherCol
      }
    
//    let sectionFooterAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 1, section: 0))
//    guard let footerFrame = delegate?.collectionView(collectionView, layout: self, referenceSizeForFooterInSection: 0) else {return}
//    sectionFooterAttributes.size = footerFrame
//
//
//    cache.append(sectionFooterAttributes)

  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
      if attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
        visibleLayoutAttributes.append(attributes)
        var frame = attributes.frame

        attributes.frame = frame
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath)
      -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
//  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    
//    switch elementKind {
//    case  UICollectionView.elementKindSectionFooter:
//      return cache.last
//    default:
//      break
//    }
//    return nil
//  }

  
}
