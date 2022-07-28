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

final class SceneLayout: UICollectionViewFlowLayout {
  
  // 1
  weak var delegate: SceneLayoutDelegate?
  
  // 2
  let numberOfColumns: Int
  let cellPadding: CGFloat
  
  // 3
  enum cacheType {
    case items
    case footer
  }
  private var cache: [cacheType: [UICollectionViewLayoutAttributes]] = [.items:[], .footer:[]]
  
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
    
    var previousItem = 0
    
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
      guard var itemAttribute = cache[.items] else {return}
      itemAttribute.append(attributes)
      cache.updateValue(itemAttribute, forKey: .items)
      
      //11
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      if numberOfColumns == 1 {continue}
      let otherCol = column == 0 ? 1:0
      column = yOffset[column] < yOffset[otherCol] ? column : otherCol

      
      let footerAtrributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: item, section: 0))
      if (previousItem != item) && ((item + 1) % 15 == 0) {
        previousItem += item
        footerAtrributes.frame = CGRect(x: 0, y: max(contentHeight, frame.maxY), width: UIScreen.main.bounds.width, height: 50)
        guard var footerAttribute = cache[.footer] else {return}
        footerAttribute.removeAll()
        footerAttribute.append(footerAtrributes)
        cache.updateValue(footerAttribute, forKey: .footer)
      }
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    guard let itemsAttributes = cache[.items],!itemsAttributes.isEmpty else {return nil}
    guard let footerAttribute = cache[.footer] else {return nil}
    
    for attributes in itemsAttributes {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    
    if footerAttribute.first?.representedElementKind == UICollectionView.elementKindSectionFooter {
      visibleLayoutAttributes.append(footerAttribute.first!)
    }
    
    return visibleLayoutAttributes
  }
  
  
  override func layoutAttributesForItem(at indexPath: IndexPath)
  -> UICollectionViewLayoutAttributes? {
    guard let itemsAttributes = cache[.items],!itemsAttributes.isEmpty else {return nil}
    return itemsAttributes[indexPath.item]
  }

}
