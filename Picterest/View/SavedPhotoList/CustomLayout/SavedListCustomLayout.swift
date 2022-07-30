//
//  SavedListCustomLayout.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation
import UIKit
import CoreGraphics

protocol SavedCustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class SavedPhotoListCustomLayout : UICollectionViewLayout {
    
    weak var delegate : SavedCustomLayoutDelegate?
    
    fileprivate var numberOfColumns: Int = 1
    fileprivate var cellPadding: CGFloat = 10.0
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentHeight: CGFloat = 0.0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        
        let columnWidth: CGFloat = contentWidth
        let xOffset: CGFloat = 0
        
        var column = 0
        var yOffset : CGFloat = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageWidth = delegate?.collectionView(collectionView, widthForImageAtIndexPath: indexPath) ?? 0
            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
            let ratio = imageHeight * contentWidth / imageWidth
            let height = cellPadding * 2 + ratio
            let frame : CGRect = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset += height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

