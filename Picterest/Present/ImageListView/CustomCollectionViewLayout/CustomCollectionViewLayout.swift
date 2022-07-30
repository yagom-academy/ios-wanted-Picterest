//
//  CustomCollectionViewLayout.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewLayout {
    
    private enum Define {
        static let cellPadding:CGFloat = 6
    }
    
    private enum Math {
        static var contentHeight: CGFloat = 0
        static var height: [Int:CGFloat] = [:]
        static var maxHeight: CGFloat = 0.0
        static var xOffset: [CGFloat] = []
        static var yOffset: [CGFloat] = []
        static var numberOfColumns: Int = 0
    }
    
    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    private var cache: [UICollectionViewLayoutAttributes]?
    private var sectionOneFooterCache: UICollectionViewLayoutAttributes?

    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: Math.contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        initCumlativeValue()
        prepareSectionOneCellLayout()
        prepareSectionOneFooterLayout(maxHeight: Math.maxHeight)
    }
    
    private func initCumlativeValue() {
        Math.height.removeAll()
        Math.maxHeight = 0.0
        Math.contentHeight = 0.0
        Math.numberOfColumns = delegate?.collectionView(numberOfColumnsInSection: 0) ?? 1
        Math.xOffset = [CGFloat]()
        Math.yOffset = [CGFloat](repeating: 0, count: Math.numberOfColumns)
        cache = [UICollectionViewLayoutAttributes]()
        sectionOneFooterCache = nil
    }

    private func prepareSectionOneCellLayout() {
        guard let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(Math.numberOfColumns)
        
        for col in 0 ..< Math.numberOfColumns {
            Math.xOffset.append(CGFloat(col) * columnWidth)
        }
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let frame = calculateCellFrame(row: item, calculateColumnHeightFunc: calculateCellHeight(row:), columnWidth: columnWidth)
            let insetFrame = frame.insetBy(dx: Define.cellPadding, dy: Define.cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attributes.frame = insetFrame
            cache?.append(attributes)
        }
        calculateMaxHeight()
    }
    
    private func calculateCellFrame(row: Int, calculateColumnHeightFunc: (Int)->CGFloat, columnWidth: CGFloat) -> CGRect {
        let height = calculateColumnHeightFunc(row)
        let column = correctColumn(numberOfColumns: Math.numberOfColumns, height: height)
        let frame = CGRect(x: Math.xOffset[column], y: Math.yOffset[column], width: columnWidth, height: height)
        Math.contentHeight = max(Math.contentHeight, frame.maxY)
        Math.yOffset[column] = Math.yOffset[column] + height
        return frame
    }
    
    private func calculateCellHeight(row: Int) -> CGFloat {
        let cellWidth = Style.Math.windowWidth/CGFloat(Math.numberOfColumns) - Define.cellPadding*2
        let photoHeight = cellWidth * (delegate?.collectionView(heightMultiplierForPhotoAtRow: row) ?? 1)
        return Define.cellPadding * 2 + photoHeight
    }
    
    private func calculateMaxHeight() {
        Math.maxHeight = Math.yOffset.reduce(0) { beforeValue, value in
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
            let insetFrame = frame.insetBy(dx: Define.cellPadding, dy: Define.cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(row: 0, section: 0))
            attributes.frame = insetFrame
            sectionOneFooterCache = attributes
            Math.contentHeight = max(Math.contentHeight, frame.maxY)
        }
    }
    
    private func correctColumn(numberOfColumns: Int, height: CGFloat) -> Int {
        var result: Int = 0
        guard numberOfColumns >= 2 else { return result }
        for i in 1..<numberOfColumns {
            guard let min = Math.height[result] else {
                Math.height.updateValue(height, forKey: result)
                return result
            }
            guard let next = Math.height[i] else {
                Math.height.updateValue(height, forKey: i)
                return i
            }
            result = min > next ? i : result
        }
        
        Math.height.updateValue((Math.height[result] ?? 0)+height, forKey: result)
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
