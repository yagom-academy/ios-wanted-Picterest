//
//  CustomLayout.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation
import UIKit
import CoreGraphics

protocol CustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CustomLayout : UICollectionViewLayout {
    
    weak var delegate : CustomLayoutDelegate?
    
    fileprivate var numberOfColumns: Int = 2
    fileprivate var cellPadding: CGFloat = 3.0
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
        
        // xOffset 계산
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            let offset = CGFloat(column) * columnWidth
            xOffset += [offset]
        }
        
        // yOffset 계산
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageWidth = delegate?.collectionView(collectionView, widthForImageAtIndexPath: indexPath) ?? 0
            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
            print(imageWidth, imageHeight)
            let ratio = imageHeight * contentWidth / imageWidth / 2
            let height = cellPadding * 2 + ratio
            let frame : CGRect = {
                if yOffset[0] <= yOffset[1] {
                    return CGRect(x: xOffset[0], y: yOffset[0], width: columnWidth, height: height)
                } else {
                    return CGRect(x: xOffset[1], y: yOffset[1], width: columnWidth, height: height)
                }
            }()
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 새로 계산된 항목의 프레임을 설명하도록 확장
            contentHeight = max(contentHeight, frame.maxY)
            if yOffset[0] <= yOffset[1] {
                yOffset[0] = yOffset[0] + height
            } else {
                yOffset[1] = yOffset[1] + height
            }
            
            // 다음 항목이 다음 열에 배치되도록 설정
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    // indexPath에 따른 layoutAttribute를 얻는 메서드 재정의
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

