//
//  FeedViewModel.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import Foundation
import Combine

class FeedViewModel {
    let key: String
    @Published var photos: Photo = []
    
    init(key: String) {
        self.key = key
        loadImage()
    }
    
    func loadImage() {
        let urlString = "https://api.unsplash.com/photos/random"
        guard var components = URLComponents(string: urlString) else {
            return
        }
        
        let query = [
            "client_id":key,
            "count":"15"
        ]
        
        let queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        components.queryItems = queryItems
        guard let requestURL = components.url else {
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print("Error in urlsession")
                return
            }
            
            guard let data = data,let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error in status code")
                return
            }
            
            guard let output = try? JSONDecoder().decode(Photo.self, from: data) else {
                print("Convert output")
                return
            }
            
            self.photos.append(contentsOf: output)
            print(self.photos)
        }
        .resume()
        
        
    }
    
}
