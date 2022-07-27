//
//  CustomCollectionViewLayout.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewLayout {
    struct CumulativeValue {
        static var height: [Int:CGFloat] = [:]
    }
    
    weak var delegate: CustomCollectionViewLayoutDelegate?

    private var windowWidth = UIScreen.main.bounds.width
    private var cellPadding: CGFloat = 6

    private var cache = [UICollectionViewLayoutAttributes]()
    private var supplementaryCache = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        prepareSectionOneCellLayout()
//        prepareSectionOneFooterLayout()
    }
    
    private func prepareSectionOneCellLayout() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let numberOfColumns = delegate?.collectionView(collectionView, numberOfColumnsInSection: 0) ?? 1
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellWidth = windowWidth/CGFloat(numberOfColumns) - cellPadding*2
            let photoHeight = cellWidth * (delegate?.collectionView(collectionView, heightMultiplierForPhotoAtIndexPath: indexPath) ?? 1)
            let height = cellPadding * 2 + photoHeight
            column = correctColumn(numberOfColumns: numberOfColumns, height: height)
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
        let maxHeight = yOffset.reduce(0) { beforeValue, value in
            return beforeValue > value ? beforeValue : value
        }
        print("a", maxHeight)
        prepareSectionOneFooterLayout(maxHeight: maxHeight)
    }
    
    private func prepareSectionOneFooterLayout(maxHeight: CGFloat) {
        
        let frame = CGRect(x: 0, y: 100, width: contentWidth, height: 100)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(row: 0, section: 0))
        attributes.frame = insetFrame
        supplementaryCache.append(attributes)
    }
    
    private func correctColumn(numberOfColumns: Int, height: CGFloat) -> Int {
        var result: Int = 0
        guard numberOfColumns >= 2 else { return result }
        for i in 1..<numberOfColumns {
            guard let min = CumulativeValue.height[result] else {
                CumulativeValue.height.updateValue(height, forKey: result)
                return result
            }
            guard let next = CumulativeValue.height[i] else {
                CumulativeValue.height.updateValue(height, forKey: i)
                return i
            }
            result = min > next ? i : result
        }
        CumulativeValue.height.updateValue((CumulativeValue.height[result] ?? 0)+height, forKey: result)
        return result
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        visibleLayoutAttributes.append(supplementaryCache[0])
        return visibleLayoutAttributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        return supplementaryCache[0]
    }

//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item]
//    }
}
