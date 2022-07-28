//
//  SavedImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import UIKit

class SavedImageListViewModel {
    private var cellDatas: [CoreDataInfo] = []
    var totalCellCount: Int {
        return cellDatas.count
    }
    
    func cellData(_ indexPath: IndexPath) -> CoreDataInfo? {
        return cellDatas[safe: indexPath.row]
    }

    func loadData(completion: @escaping () -> ()) {
        CoreDataManager.shared.getImageInfos { [weak self] infos in
            self?.cellDatas = infos
            completion()
        }
    }
    
    func cellSize(_ indexPath: IndexPath) -> CGSize {
        let aspectRatio = cellDatas[indexPath.row].aspectRatio
        let padding = 10.0
        let width = UIScreen.main.bounds.width - 2*padding
        let height = width*aspectRatio
        return CGSize(width: width, height: height)
    }
}
