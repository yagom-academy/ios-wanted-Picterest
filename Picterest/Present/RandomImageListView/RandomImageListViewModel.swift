//
//  RandomImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class RandomImageListViewModel {
    
    private let networkManager: NetworkManager
    private var imageInfos: [ImageInfo] = []
    var cellTotalCount: Int {
        return imageInfos.count
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func cellData(_ indexPath: IndexPath) -> ImageInfo? {
        return imageInfos[safe: indexPath.row]
    }
    
    func cellHeightMultiplier(_ indexPath: IndexPath) -> CGFloat {
        guard let data = imageInfos[safe: indexPath.row] else { return 0.0 }
        let multiplier = CGFloat(data.height) / CGFloat(data.width)
        return multiplier
    }
    
    func loadData(completion: @escaping (Result<Void,CustomError>) -> ()) {
        networkManager.getRandomImageInfo { result in
            switch result {
            case .success(let infos):
                self.imageInfos = infos
                print("success load data!")
                completion(.success(Void()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
