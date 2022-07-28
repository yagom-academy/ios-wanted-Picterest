//
//  RandomImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class ImageListViewModel {
    
    struct CellData {
        var thumbnailURL: String
        var isSaved: Bool
        var id: UUID
        mutating func toggleSavedState() {
            self.isSaved = !self.isSaved
        }
    }
    
    private let networkManager: NetworkManager
    private var networkDatas: [ImageInfo] = []
    private var cellDatas: [CellData] = []
    private var currentPage: Int = 1
    var totalCellCount: Int {
        return cellDatas.count
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func cellData(_ indexPath: IndexPath) -> CellData? {
        return cellDatas[safe: indexPath.row]
    }
    
    func cellHeightMultiplier(_ indexPath: IndexPath) -> CGFloat {
        guard let data = networkDatas[safe: indexPath.row] else { return 0.0 }
        let multiplier = CGFloat(data.height) / CGFloat(data.width)
        return multiplier
    }
    
    func loadData(completion: @escaping (Result<Void,CustomError>) -> ()) {
        networkManager.getImageInfo(page: currentPage) { [weak self] result in
            switch result {
            case .success(let infos):
                self?.networkDatas += infos
                self?.cellDatas += infos.map({ info in
                    let isSaved:Bool = CoreDataManager.shared.containImage(imageURL: info.imageURL.thumbnail)
                    return CellData(thumbnailURL: info.imageURL.thumbnail, isSaved: isSaved, id: UUID())
                })
                print("success load data!")
                self?.currentPage += 1
                completion(.success(Void()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func saveImage(row: Int, message: String, completion: @escaping (Result<Void, DBManagerError>) -> ()) {
        let imageURL = cellDatas[row].thumbnailURL
        let id = cellDatas[row].id
        ImageFileManager.shared.saveImageByURL(imageURL: imageURL, id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let location):
                let aspectRatio = Double(self.networkDatas[row].height)/Double(self.networkDatas[row].width)
                let succeedSaveImageInfo = CoreDataManager.shared.saveImageInfo(CoreDataInfo(id: id, message: message, aspectRatio: aspectRatio, imageURL: imageURL, imageFileLocation: location))
                self.cellDatas[row].toggleSavedState()
                completion(succeedSaveImageInfo ? .success(Void()) : .failure(.failToSaveImageInfo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
