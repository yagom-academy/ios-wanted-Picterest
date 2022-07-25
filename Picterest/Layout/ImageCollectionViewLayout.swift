//
//  ImageCollectionViewLayout.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import UIKit

protocol ImageCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class ImageCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: ImageCollectionViewLayoutDelegate?
    
    private var numberOfColumns: Int = 1
    
    private let cellPadding: CGFloat = 3
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func setNumberOfColumns(numOfColumns : Int) {
        numberOfColumns = numOfColumns
    }
    
    func getNumberOfColumns() -> Int {
        return numberOfColumns
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView,heightForImageAtIndexPath: indexPath) ?? 180
            
            let height = cellPadding * 2 + photoHeight
            
            let frame = CGRect(x: xOffset[column],y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            if numberOfColumns == 1 {
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }else{
                column = yOffset[0] > yOffset[1] ? 1 : 0
            }
        }
    }
    //보이는 화면 내부의 모든 레이아웃 속성 저장 및 반환
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    //요청한 레이아웃 반환
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
