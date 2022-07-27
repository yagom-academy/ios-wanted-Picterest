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
    private let cellPadding: CGFloat = 6
    
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
        
        // MARK: contentsWidth를 계산하고, xOffset과 yOffset을 만들어둔다.
        // - xOffset, yOffset은 이후 모든 아이템들의 사이즈를 계산할때 사용되며 갱신된다.
        
        let columnWidth = contentWidth / CGFloat(numberOfColums)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColums {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColums)
        
        // MARK: 모든 아이템들의 사이즈를 계산하며 cache에 저장한다.
        // - yOffset과 xOffset을 계속 갱신한다.
        // - contentHeight를 계속 가장 큰값으로 갱신한다.
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            //5
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColums - 1) ? (column + 1) : 0
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
