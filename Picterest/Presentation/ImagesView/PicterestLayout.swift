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
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

class PicterestLayout: UICollectionViewLayout {
    weak var delegate: PicterstLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    //다시 레이아웃을 계산할 필요가 없도록 메모리에 저장
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
    
    //1. 컬렉션뷰의 콘텐츠 사이즈를 지정
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //2. 컬렉션뷰가 처음 초기화 되거나 뷰가 변경될 때 실행, 이 메서드에서 레이아웃을 미리 계산해 메모리에 적재하고 필요할 때마다 효율적으로 접근할 수 있도록 구현해야 한다.
    override func prepare() {
        
        //1캐시가 비어있고 컬렉션뷰가 있는 경우에만 레이아웃 속성 계산
        guard cache.isEmpty,
              let collectionView = collectionView else { return }
        //2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = [] //cell의 x위치를 나타내는 배열
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0 // 현재 행의 위치
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns) // cell의 y위치를 나타내는 배열
        
        //3 섹션이 하나만 있으면 첫번째 섹션의 모든 항목 반복
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            //IndexPath에 맞는 셀의 크기, 위치를 계산
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate?.collectionView(collectionView, sizeOfPhotoAtIndexPath: indexPath) ?? CGSize(width: 180, height: 180)
            
            let cellWidth = columnWidth
            var cellHeight = photoSize.height * cellWidth / photoSize.width
            
            cellHeight = cellPadding * 2 + cellHeight
            
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: cellWidth,
                               height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            //위에서 계산한 Frame을 기반으로 cache에 들어갈 레이아웃 정보를 추가
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            //컬렉션뷰의 contentHeight를 다시 지정
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            
            //다른 이미지 크기로 인해서, 한쪽 열에만 이미지가 추가되는 것을 방지
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    //3. 모든 셀과 보충 뷰의 레이아웃 정보를 리턴한다. 화면 표시 영역 기반(Rect)의 요청이 들어올 때 사용한다.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributs: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) { //셀 frame과 요청 Rect가 교차한다면, 리턴 값에 추가
                visibleLayoutAttributs.append(attributes)
            }
        }
        return visibleLayoutAttributs
    }
    
    //4. 모든 셀의 레이아웃 정보를 리턴, IndexPath로 요청이 들어올 때 이 메서드를 사용
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
