//
//  PhotoManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

struct PhotoManager {
    
    let base = "https://api.unsplash.com"
    
    private let apiKey = "sRobjHR_YJo2sphiIADOISpCsrtIywIwxeABhC23E0I"
    
    func getData(_ perPage : Int, _ pageNumber : Int, completion : @escaping ([Photo]) -> Void ) {
        let api = makeApi(base, apiKey)
        if let url = URL(string: fetchURL(perPage, pageNumber, api)) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                let successRange = 200..<300
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {return}
                if successRange.contains(statusCode) {
                    if let safeData = data {
                        guard let result = self.parseJSON(safeData) else {return}
                        completion(result)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> [Photo]? {
        let decorder = JSONDecoder()
        do {
            let decodeData = try decorder.decode([Photo].self, from: data)
            return decodeData
        } catch {
            return nil
        }
    }
    
    func makeApi(_ base : String, _ apiKey : String) -> String {
        return "\(base)/photos/?client_id=\(apiKey)"
    }
    
    func fetchURL(_ perPage : Int, _ pageNumber : Int, _ api : String) -> String {
        let urlString = api + "&page=\(pageNumber)&per_page=\(perPage)"
        return urlString
    }
}
