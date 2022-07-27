//
//  RandomImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class RandomImageListViewModel {
    struct CellData {
        var thumbnailURL: String
        var isSaved: Bool
        mutating func toggleSavedState() {
            self.isSaved = !self.isSaved
        }
    }
    
    private let networkManager: NetworkManager
    private var networkDatas: [ImageInfo] = []
    private var cellDatas: [CellData] = []
    var cellTotalCount: Int {
        return networkDatas.count
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
        networkManager.getRandomImageInfo { [weak self] result in
            switch result {
            case .success(let infos):
                self?.networkDatas += infos
                self?.cellDatas += infos.map({ info in
                    return CellData(thumbnailURL: info.imageURL.thumbnail, isSaved: false)
                })
                print("success load data!")
                completion(.success(Void()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func tappedStarButton(indexPath: IndexPath) {
        guard cellDatas[safe: indexPath.row] != nil else { return }
        cellDatas[indexPath.row].toggleSavedState()
    }
}
