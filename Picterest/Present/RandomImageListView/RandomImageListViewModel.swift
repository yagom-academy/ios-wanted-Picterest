//
//  RandomImageListViewModel.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

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
        return imageInfos[indexPath.row]
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
