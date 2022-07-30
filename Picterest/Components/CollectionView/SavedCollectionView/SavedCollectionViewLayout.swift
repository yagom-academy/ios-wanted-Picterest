//
//  SavedCollectionViewLayout.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/28.
//

import UIKit

protocol SavedCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, ratioForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class SavedCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: SavedCollectionViewLayoutDelegate?
    
    private var numberOfColumns: Int = 1
    private var cellPadding: CGFloat = 12.0
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0.0
    
    private var contentWidth: CGFloat {
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
        
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            let offset = CGFloat(column) * columnWidth
            xOffset += [offset]
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = delegate?.collectionView(collectionView, ratioForImageAtIndexPath: indexPath) ?? 0
            
            let height = cellPadding * 2 + columnWidth * ratio
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = frame.maxY
            yOffset[column] = yOffset[column] + height
            
            // 다음 항목이 다음 열에 배치되도록 설정
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter {rect.intersects($0.frame)}
    }
}
