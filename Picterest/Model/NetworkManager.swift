//
//  NetworkManager.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation

final class NetworkManager {
    
    func fetchData(completion: @escaping ([PhotoModel]) -> Void) {
        
        guard let url = URL(string: Constant.Network.downloadURL + "?" + "client_id=\(Constant.Network.clientKey)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let safeData = data, error == nil else {
                    print("Download image fail : \(url)")
                    return
            }

            DispatchQueue.main.async() {
                print("Download image success : \(url)")
                do {
                    let decodedData = try JSONDecoder().decode([PhotoModel].self, from: safeData)
                    completion(decodedData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
