//
//  SavedViewModel.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/29.
//

import Foundation

protocol SavedImageAble {
    var savedImages: [savedModel] { get }
    var savedImagesPublisher: Published<[savedModel]>.Publisher { get }
    var isReLoadViewPublisher: Published<Bool>.Publisher { get }
    func fetchData()
    func deleteData(_ index: Int)
    func resetData()
    func changeReLoadState()
}

class SavedViewModel: SavedImageAble {
    private let coreDataService = CoreDataService.shared
    private let downloadManager = DownLoadManager()
    @Published var savedImages: [savedModel] = []
    var savedImagesPublisher: Published<[savedModel]>.Publisher { $savedImages }
    @Published var isReLoadView: Bool = false
    var isReLoadViewPublisher: Published<Bool>.Publisher { $isReLoadView }
    
    func fetchData() {
        savedImages.removeAll()
        savedImages = coreDataService.fetch()
    }
    
    func deleteData(_ index: Int) {
        let data = savedImages[index]
        let result = coreDataService.fetchManagement()
        
        if coreDataService.delete(object: result[index]) {
            if downloadManager.removeData(data.file ?? "") {
                self.resetData()
                isReLoadView = true
            }
        }
    }
    
    func resetData() {
        savedImages.removeAll()
    }
    
    func changeReLoadState() {
        isReLoadView = false
    }
}
