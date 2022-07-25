//
//  PhotoManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation

struct PhotoManager {
    
    let api = "https://api.unsplash.com/photos/?client_id=sRobjHR_YJo2sphiIADOISpCsrtIywIwxeABhC23E0I"
    
    func getData(completion : @escaping (PhotoList) -> Void ) {
        if let url = URL(string: api) {
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
    
    func parseJSON(_ data : Data) -> PhotoList? {
        let decorder = JSONDecoder()
        do {
            let decodeData = try decorder.decode(PhotoList.self, from: data)
            return decodeData
        } catch {
            return nil
        }
    }
}
