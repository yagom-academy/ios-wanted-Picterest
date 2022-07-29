//
//  CustomCollectionViewLayout.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewLayout {
    enum CumulativeValue {
        static var height: [Int:CGFloat] = [:]
        static var maxHeight: CGFloat = 0.0
    }
    
    weak var delegate: CustomCollectionViewLayoutDelegate?

    private var windowWidth = UIScreen.main.bounds.width
    private var cellPadding: CGFloat = 6

    private var cache: [UICollectionViewLayoutAttributes]?
    private var sectionOneFooterCache: UICollectionViewLayoutAttributes?

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
        initCumlativeValue()
        prepareSectionOneCellLayout()
        prepareSectionOneFooterLayout(maxHeight: CumulativeValue.maxHeight)
    }
    
    private func initCumlativeValue() {
        CumulativeValue.height.removeAll()
        CumulativeValue.maxHeight = 0.0
        contentHeight = 0.0
        cache = [UICollectionViewLayoutAttributes]()
        sectionOneFooterCache = nil
    }

    private func prepareSectionOneCellLayout() {
        guard let collectionView = collectionView else {
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
            cache?.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
        CumulativeValue.maxHeight = yOffset.reduce(0) { beforeValue, value in
            return beforeValue > value ? beforeValue : value
        }
    }
    
    private func prepareSectionOneFooterLayout(maxHeight: CGFloat) {
        guard let collectionView = collectionView else {
            return
        }
        if (collectionView.numberOfItems(inSection: 0) > 0) {
            let indexPath = IndexPath(row: 0, section: 0)
            let frame = CGRect(x: 0, y: maxHeight, width: contentWidth, height: (delegate?.collectionView(heightFooterAtIndexPath: indexPath) ?? 0))
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(row: 0, section: 0))
            attributes.frame = insetFrame
            sectionOneFooterCache = attributes
            contentHeight = max(contentHeight, frame.maxY)
        }
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
        guard let cache = cache else {
            return []
        }

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        guard let supplementaryAttributes = sectionOneFooterCache else { return visibleLayoutAttributes }
        if supplementaryAttributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(supplementaryAttributes)
        }
        return visibleLayoutAttributes
    }
}
