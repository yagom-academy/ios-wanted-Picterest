//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation
import Combine

class PhotoListViewModel : ObservableObject {
    
    @Published var photoList : PhotoList?
    let photoManager = PhotoManager()
    
    // 별도의 이모지를 추가해도 좋습니다.
    let emojies = ["1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟"]

    func getDataFromServer() {
        photoManager.getData { [weak self] photoList in
            self?.photoList = photoList
        }
    }
}
