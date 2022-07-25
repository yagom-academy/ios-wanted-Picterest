//
//  NetworkManager.swift
//  Picterest
//
//  Created by BH on 2022/07/25.
//

import Foundation

class NetworkManager {
    
    func fetchPhotos() {
        let apiKey = Bundle.main.apiKey
        let url = "https://api.unsplash.com/photos/?client_id=\(apiKey)"
    }

}
