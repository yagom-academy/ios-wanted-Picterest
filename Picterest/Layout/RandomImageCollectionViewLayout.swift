//
//  RandomImageCollectionViewLayout.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

protocol RandomImageCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class RandomImageCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: RandomImageCollectionViewLayoutDelegate?
    
    private let numberOfColumns: Int = 2
    private let cellPadding: CGFloat = 5
    private var imageHeight: CGFloat = 0
    private var imageWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        let columnWidth = imageWidth / CGFloat(numberOfColumns)
        // cell의 X위치
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        // cell의 y위치
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        // 현재 행의 위치
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            // indexPath에 맞는 셀의 rect 계산
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForImageAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 위에서 계산한 frame을 기반으로 cache에 들어갈 레이아웃 정보 추가
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            imageHeight = max(imageHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // 짧은쪽 이미지에 다음 아이템 추가
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
        if collectionView?.numberOfItems(inSection: 0) == cache.count {
            return cache[indexPath.item]
        } else {
            return nil
        }
    }
}
