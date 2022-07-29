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
    
    private let numberOfColumns = UIStyle.CustomLayout.numberOfColumns
    private let cellPadding: CGFloat = 4
    private var yOffset: [CGFloat] = .init(repeating: 0, count: UIStyle.CustomLayout.numberOfColumns)
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var column = 0
    
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
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if numberOfItems == cache.count { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        for item in cache.count..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            guard let photoWidth = delegate?.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath),
                  let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) else { return }
            let height = cellPadding + (photoHeight * columnWidth) / photoWidth
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = yOffset[0] <= yOffset[1] ? 0 : 1
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
