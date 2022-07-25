//
//  PhotoListCollectionViewLayout.swift
//  Picterest
//
//  Created by 효우 on 2022/07/25.
//

import UIKit

protocol PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView:UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath
    ) -> CGFloat
}

class PhotoListCollectionViewLayout: UICollectionViewLayout {
    var delegate: PhotoListCollectionViewLayoutDelegate?
    private var numberOfcolumns = 2
    private var cellPadding: CGFloat = 5
    private var cache = [UICollectionViewLayoutAttributes]()
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
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfcolumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfcolumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfcolumns)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            guard let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath
            ) else { return }
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: height
            )
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfcolumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
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
        return cache[indexPath.row]
    }
}
