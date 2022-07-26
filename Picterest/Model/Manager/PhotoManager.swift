//
//  PhotoManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

struct PhotoManager {
    
    let baseApi = "https://api.unsplash.com/photos/?client_id=sRobjHR_YJo2sphiIADOISpCsrtIywIwxeABhC23E0I"
    
    func fetchURL(_ perPage : Int, _ pageNumber : Int, _ api : String) -> String {
        let urlString = api + "&page=\(pageNumber)&per_page=\(perPage)"
        return urlString
    }
    
    func getData(_ perPage : Int, _ pageNumber : Int, completion : @escaping ([Photo]) -> Void ) {
        if let url = URL(string: fetchURL(perPage, pageNumber, baseApi)) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    guard let result = self.parseJSON(safeData) else {return}
                    completion(result)
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
}
