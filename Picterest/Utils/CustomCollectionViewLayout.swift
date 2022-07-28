//
//  CustomCollectionViewLayout.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {

    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    private let numberOfColums = 2
    private let cellPadding: CGFloat = 3.0
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
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
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColums)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColums {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColums)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath
            ) ?? 180
            
            let photoWidth = delegate?.collectionView(
                collectionView,
                widthForPhotoAtIndexPath: indexPath
            ) ?? columnWidth
            let height = cellPadding * 2 + columnWidth * photoHeight / photoWidth
            
            let frame1 = CGRect(x: xOffset[0], y: yOffset[0], width: columnWidth, height: height)
            let frame2 = CGRect(x: xOffset[1], y: yOffset[1], width: columnWidth, height: height)

            if frame1.maxY > frame2.maxY {
                // frame2에 몰아야함
                let insetFrame = frame2.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame2.maxY)
                yOffset[1] = yOffset[1] + height

            } else {
                let insetFrame = frame1.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame1.maxY)
                yOffset[0] = yOffset[0] + height

            }
        }
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
