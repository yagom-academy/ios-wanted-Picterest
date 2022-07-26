//
//  ImageCollectionViewCustomLayout.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class ImageColletionViewCustomLayout: UICollectionViewFlowLayout {
    
    weak var delegate: CustomLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = [] // 셀 갯수
    
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
        
        let numberOfColumns = 2 // 한 줄에 몇개
        let cellPadding: CGFloat = 6 // 패딩
        let cellWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        var column = 0
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * cellWidth)
        }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: cellWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = yOffset[0] > yOffset[1] ? 1 : 0
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
