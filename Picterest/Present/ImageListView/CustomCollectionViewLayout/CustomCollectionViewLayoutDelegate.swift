//
//  CustomCollectionViewDelegate.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(heightMultiplierForPhotoAtRow row: Int) -> CGFloat
    func collectionView(numberOfColumnsInSection section: Int) -> Int
    func collectionView(heightFooterAtIndexPath indexPath: IndexPath) -> CGFloat
}
