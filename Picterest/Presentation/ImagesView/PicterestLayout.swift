//
//  PicterestLayout.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import Foundation
import UIKit

protocol PicterstLayoutDelegate: AnyObject {
    //사진의 높이 요청 메소드
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PicterestLayout: UICollectionViewLayout {
    weak var delegate: PicterstLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        //컬렉션뷰의 너비와 해당 컨텐츠 인셋 기반으로 계산됨
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //컬렉션뷰 콘텐츠의 크기를 반환
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //레이아웃 작업이 발생하려고 할때마다  UIKit이 이 메소드 호출, 컬렉션뷰의 크기와 항목 위치 결정하는데 필요한 계산 준비하고 수행
    override func prepare() {
        
        //1캐시가 비어있고 컬렉션뷰가 있는 경우에만 레이아웃 속성 계산
        guard cache.isEmpty,
              let collectionView = collectionView else { return }
        //2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        //3 섹션이 하나만 있으면 첫번째 섹션의 모든 항목 반복
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            //4
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            //5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            //6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributs: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributs.append(attributes)
            }
        }
        return visibleLayoutAttributs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
