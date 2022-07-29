//
//  SavedViewModel.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/29.
//

import Foundation


class SavedViewModel: ObservableObject {
    private let coreDataService = CoreDataService.shared
    private let downloadManager = DownLoadManager()
    @Published var savedImages: [savedModel] = []
    @Published var isReLoadView: Bool = false
    
    func fetchData() {
        savedImages.removeAll()
        if let datas = coreDataService.fetch() as? [SavedModel] {
            datas.forEach {
                let savedModel = savedModel(id: $0.id,
                                            memo: $0.memo,
                                            file: $0.fileURL,
                                            raw: $0.rawURL)
                self.savedImages.append(savedModel)
            }
        }
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
}
