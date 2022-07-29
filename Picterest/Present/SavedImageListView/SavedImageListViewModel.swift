//
//  SavedImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import UIKit

final class SavedImageListViewModel {
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
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func cellSize(_ indexPath: IndexPath) -> CGSize {
        let aspectRatio = cellDatas[indexPath.row].aspectRatio
        let padding = 10.0
        let width = UIScreen.main.bounds.width - 2*padding
        let height = width*aspectRatio
        return CGSize(width: width, height: height)
    }
    
    func removeCell(at id: UUID, completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            do {
                let fileLocation = try CoreDataManager.shared.removeImageInfo(at: id)
                try ImageFileManager.shared.removeImage(at: fileLocation)
                self?.loadData(completion: completion)
            } catch {
                if let error = error as? DBManagerError {
                    print(error.description)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
