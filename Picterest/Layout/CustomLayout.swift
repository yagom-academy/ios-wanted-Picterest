//
//  CustomLayout.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {
    
    weak var delegate: CustomLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 4
    private var heightArray: [CGFloat] = [0, 0]
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        print(insets)
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        if numberOfItems == cache.count { return }
        
        cache.removeAll()
        heightArray = [0, 0]
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = calculateColumnValue()
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let photoWidth = delegate?.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath) ?? 180
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding + (photoHeight * columnWidth) / photoWidth
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            setHeightArray(with: height, at: column)
            column = calculateColumnValue()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}

extension CustomLayout {
    
    private func calculateColumnValue() -> Int {
        if heightArray[0] == 0 && heightArray[0] == 0 {
            return 0
        }
        
        if heightArray[0] > heightArray[1] {
            return 1
        } else {
            return 0
        }
    }
    
    private func setHeightArray(with height: CGFloat, at column: Int) {
        if heightArray[0] == 0 && heightArray[0] == 0 {
            heightArray[0] = height
        } else if heightArray[0] == 0 {
            heightArray[0] = height
        } else if heightArray[1] == 0 {
            heightArray[1] = height
        } else {
            heightArray = [0, 0]
            heightArray[column] = height
        }
    }
}
