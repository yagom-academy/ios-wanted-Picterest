//
//  PhotoListCollectionViewLayout.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

protocol PhotoListCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat
}

class PhotoListCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: PhotoListCollectionViewLayoutDelegate?
    
    private let numberOfColumns = 2
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
        guard let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns) // 셀의 가로 길이
        var xOffset: [CGFloat] = [] // x좌표 배열
        for column in 0..<numberOfColumns { // 열의 개수만큼
            xOffset.append(CGFloat(column) * columnWidth) // x좌표 배열에 (현재 열 * 셀의 가로 길이 = 셀이 위치할 x좌표) append
        }
        
        var column = 0
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColumns) // y좌표 배열
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) { // 콜렉션뷰의 0번째 섹션의 아이템의 개수만큼
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView( // 델리게이트로 받아온 셀의 높이
                collectionView,
                heightForPhotoAtIndexPath: indexPath
            )
            let height = cellPadding * 2 + (photoHeight ?? 180) // 셀의 높이는 셀 위아래 여백 포함(나중에 insetBy로 줄일 예정이므로)
            let frame = CGRect( // 셀의 source 프레임 설정
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: height
            )
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding) // 셀의 여백 추가
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)  // attribute 생성
            attributes.frame = insetFrame
            cache.append(attributes) // 캐시에 저장
            
            contentHeight = max(contentHeight, frame.maxY) // 프레임 높이 업데이트
            yOffset[column] = yOffset[column] + height
            
            column = yOffset[0] > yOffset[1] ? 1 : 0
        }
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
