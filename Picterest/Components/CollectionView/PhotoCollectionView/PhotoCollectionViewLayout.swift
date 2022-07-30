//
//  CustomLayout.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/27.
//

import UIKit

protocol PhotoCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, ratioForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PhotoCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: PhotoCollectionViewLayoutDelegate?
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 3.0
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
            
            // 새로 계산된 항목의 프레임을 설명하도록 확장
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // 다음 항목이 다음 열에 배치되도록 설정
            guard let minYoffset = yOffset.min(), let index = yOffset.firstIndex(of: minYoffset) else { return }
            
            column = index
        }
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter {rect.intersects($0.frame)}
    }
}
